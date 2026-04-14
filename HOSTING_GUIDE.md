# 🌐 HOSTING PREPARATION GUIDE
## UA Electronics - Domain: uaelectronicsindia.com

---

## 📋 PRE-HOSTING CHECKLIST

- [ ] Register domain: uaelectronicsindia.com
- [ ] Get SSL certificate (Let's Encrypt - FREE)
- [ ] Choose hosting provider (AWS, DigitalOcean, Heroku, etc.)
- [ ] Configure DNS records
- [ ] Setup Node.js environment
- [ ] Configure environment variables
- [ ] Setup database backup strategy
- [ ] Configure email production account
- [ ] Setup Razorpay production keys
- [ ] Setup monitoring & logging

---

## 🚀 DEPLOYMENT OPTIONS

### Option 1: Digital Ocean (Recommended for Beginners)
**Estimated Cost**: $5-10/month

#### Setup:
1. Create account at www.digitalocean.com
2. Create Droplet (Ubuntu 22.04 LTS - $5/month)
3. SSH into droplet: `ssh root@YOUR_IP`
4. Run setup script:
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2 (process manager)
sudo npm install -g pm2

# Install Nginx (reverse proxy)
sudo apt install -y nginx

# Clone your repository
git clone YOUR_REPO_URL /var/www/uaelectronics
cd /var/www/uaelectronics

# Install dependencies
npm install

# Create .env file
nano .env
```

4. Configure `.env`:
```env
NODE_ENV=production
PORT=3000
EMAIL_USER=your_gmail@gmail.com
EMAIL_PASS=your_app_password
RAZORPAY_KEY_ID=YOUR_PRODUCTION_KEY
RAZORPAY_KEY_SECRET=YOUR_PRODUCTION_SECRET
```

5. Start application with PM2:
```bash
pm2 start server.js --name "ua-electronics"
pm2 save
pm2 startup
```

---

### Option 2: AWS (Most Scalable)
**Estimated Cost**: $1-20/month + data transfer

#### Setup:
1. Create AWS account
2. Launch EC2 instance (t3.micro - FREE tier eligible)
3. Use Amazon RDS for MySQL (optional, replaces JSON storage)
4. Use Amazon S3 for Order PDFs storage
5. Use CloudFront for CDN
6. Follow similar Node.js setup as Digital Ocean

---

### Option 3: Heroku (Easiest but Closes Paid Tiers)
**Note**: Free tier not available, but very easy deployment

#### Setup:
```bash
# Install Heroku CLI
npm install -g heroku

# Login to Heroku
heroku login

# Create Heroku app
heroku create ua-electronics-india

# Add environment variables
heroku config:set EMAIL_USER=your_email@gmail.com
heroku config:set EMAIL_PASS=your_app_password
heroku config:set RAZORPAY_KEY_ID=xxxxx
heroku config:set RAZORPAY_KEY_SECRET=xxxxx

# Deploy
git push heroku main
```

---

## 🔒 SSL SETUP (Let's Encrypt - FREE)

### Using Certbot with Nginx:
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get certificate
sudo certbot certonly --nginx -d uaelectronicsindia.com

# Auto-renew
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
```

---

## 🔧 NGINX CONFIGURATION

Create `/etc/nginx/sites-available/uaelectronics`:

```nginx
upstream ua_electronics {
  server 127.0.0.1:3000;
}

server {
  listen 80;
  listen [::]:80;
  server_name uaelectronicsindia.com www.uaelectronicsindia.com;
  
  # Redirect HTTP to HTTPS
  return 301 https://$server_name$request_uri;
}

server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name uaelectronicsindia.com www.uaelectronicsindia.com;

  # SSL certificates
  ssl_certificate /etc/letsencrypt/live/uaelectronicsindia.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/uaelectronicsindia.com/privkey.pem;

  # Performance optimizations
  client_max_body_size 10M;
  gzip on;
  gzip_types text/plain text/css application/json application/javascript;

  # Root directory
  root /var/www/uaelectronics;

  # Proxy API requests
  location ~ ^/(api|products|orders|track|login|register|save-order|create-order) {
    proxy_pass http://ua_electronics;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_buffering off;
    proxy_request_buffering off;
  }

  # Serve static files
  location ~* \.(css|js|jpg|jpeg|png|gif|svg|woff|woff2|ttf|eot)$ {
    expires 30d;
    add_header Cache-Control "public, immutable";
  }

  # Main page
  location / {
    try_files $uri $uri/ /index.html;
  }
}
```

Enable site:
```bash
sudo ln -s /etc/nginx/sites-available/uaelectronics /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## 🗄️ DATABASE MIGRATION (Optional)

### Upgrade from JSON to MongoDB:

1. Install MongoDB Atlas (free cloud database)
2. Update server.js:
```javascript
const mongoose = require('mongoose');

mongoose.connect(process.env.MONGODB_URI);

// Define schemas
const orderSchema = new mongoose.Schema({
  orderId: String,
  customer: Object,
  items: Array,
  grand: Number,
  paymentStatus: String,
  date: Date
});

const Order = mongoose.model('Order', orderSchema);

// Replace file operations with database
app.post('/save-order', async (req, res) => {
  const order = new Order(req.body);
  await order.save();
  res.json({ success: true });
});
```

---

## 📊 PRODUCTION LOGGING & MONITORING

### Setup PM2 Plus (Monitoring):
```bash
# Link PM2
pm2 link YOUR_PM2_PLUS_KEY YOUR_PM2_PLUS_SECRET

# Enable cluster mode (auto-restart on crash)
pm2 restart server --update-env --exp

# View logs
pm2 logs
pm2 monit
```

### Setup Application Logging:
```javascript
const fs = require('fs');
const path = require('path');

// Log to file
const logFile = path.join(__dirname, 'logs/app.log');
const logStream = fs.createWriteStream(logFile, { flags: 'a' });

function log(message) {
  const timestamp = new Date().toISOString();
  logStream.write(`[${timestamp}] ${message}\n`);
  console.log(`[${timestamp}] ${message}`);
}
```

---

## 🔐 SECURITY HARDENING

### For Production:

1. **Environment Variables (.env)**
```env
NODE_ENV=production
PORT=3000
EMAIL_USER=xxx
EMAIL_PASS=xxx
RAZORPAY_KEY_ID=xxx
RAZORPAY_KEY_SECRET=xxx
DB_URL=mongodb+srv://...
JWT_SECRET=your-secret-key
```

2. **Update server.js**:
```javascript
require('dotenv').config();

app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || 'https://uaelectronicsindia.com'
}));

// Rate limiting
const rateLimit = require('express-rate-limit');
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100
});
app.use('/api/', limiter);
```

3. **Update checkout.js**:
```javascript
const API_BASE = "https://uaelectronicsindia.com";
// Remove all hardcoded test keys
```

4. **Password Hashing**:
```javascript
const bcrypt = require('bcrypt');

// On registration
const hashedPassword = await bcrypt.hash(password, 10);

// On login
const isValid = await bcrypt.compare(password, user.password);
```

---

## 📈 PERFORMANCE OPTIMIZATION

1. **Enable CDN** (Cloudflare - FREE)
   - DNS: Ultra-fast
   - Caching: Automatic
   - DDoS Protection: Included

2. **Compress Assets**:
```bash
npm install minify --save-dev
npm install minify-js minify-css --save-dev
```

3. **Database Indexing**:
```javascript
// If using MongoDB
orderSchema.index({ customerId: 1 });
orderSchema.index({ date: -1 });
```

4. **Caching** (Redis):
```javascript
const redis = require('redis');
const client = redis.createClient(process.env.REDIS_URL);

// Cache products
app.get('/products', async (req, res) => {
  const cached = await client.get('products');
  if (cached) return res.json(JSON.parse(cached));
  
  const products = JSON.parse(fs.readFileSync(PRODUCTS_FILE));
  await client.setEx('products', 3600, JSON.stringify(products));
  res.json(products);
});
```

---

## 🔄 BACKUP STRATEGY

### Automated Backups:
```bash
# Create backup script (backup.sh)
#!/bin/bash
BACKUP_DIR="/backups/ua-electronics"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup data files
tar -czf $BACKUP_DIR/data_$TIMESTAMP.tar.gz \
  /var/www/uaelectronics/data/

# Backup Orders PDFs
tar -czf $BACKUP_DIR/orders_$TIMESTAMP.tar.gz \
  /var/www/uaelectronics/Orders/

# Remove old backups (keep 30 days)
find $BACKUP_DIR -mtime +30 -delete

echo "Backup completed: $TIMESTAMP"
```

**Cron job** (run daily at 2 AM):
```bash
sudo crontab -e
# Add: 0 2 * * * /home/ubuntu/backup.sh
```

---

## 🚀 DOMAIN DNS SETUP

### At your domain registrar (GoDaddy, Namecheap, etc.):

1. **Point to your server**:
   - Type: A
   - Name: @
   - Value: YOUR_SERVER_IP

2. **Add www subdomain**:
   - Type: CNAME
   - Name: www
   - Value: uaelectronicsindia.com

3. **Email MX records** (if using custom email):
   - Type: MX
   - Priority: 10
   - Value: mail.uaelectronicsindia.com

---

## ✅ FINAL VERIFICATION CHECKLIST

Before going live:

- [ ] Test all endpoints on production domain
- [ ] Test login/registration
- [ ] Test COD order flow
- [ ] Test Online payment (use test cards)
- [ ] Verify PDFs are generating
- [ ] Verify emails are receiving (check spam)
- [ ] Test mobile responsiveness
- [ ] Check SSL certificate (green lock)
- [ ] Test with multiple browsers
- [ ] Monitor server logs
- [ ] Test backup restoration
- [ ] Verify 404 error pages
- [ ] Test sitemap.xml generation
- [ ] Verify robots.txt
- [ ] Check Core Web Vitals
- [ ] Load test with simulated users

---

## 📞 SUPPORT & MAINTENANCE

### Monthly Tasks:
- [ ] Review server logs for errors
- [ ] Update Node.js packages (`npm update`)
- [ ] Review database backups
- [ ] Monitor disk space usage
- [ ] Renew SSL certificates (auto-renew should handle this)

### Yearly Tasks:
- [ ] Security audit
- [ ] SSL certificate replacement
- [ ] Performance optimization review
- [ ] Data retention policy review
- [ ] Business continuity plan test

---

## 🎉 GOING LIVE

Once everything is tested and verified:

```bash
# Production deployment
git push production main

# Monitor
pm2 monit
tail -f logs/app.log

# Celebrate! 🎊
```

---

**Generated**: April 14, 2026  
**Domain**: uaelectronicsindia.com  
**Status**: Ready for Deployment
