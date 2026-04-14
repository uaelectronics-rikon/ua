# 🔧 UA ELECTRONICS - CONFIGURATION GUIDE

## Step 1: Configure Email Service (Gmail)

### Prerequisites:
- Gmail account
- Gmail App Password (NOT regular password)

### Setup Gmail App Password:

1. Go to: https://myaccount.google.com/security
2. Enable **2-Step Verification** if not already enabled
3. Search for **"App passwords"** in Security settings
4. Select App: **Mail** | Device: **Windows/Mac/Other**
5. Generate password (16 characters)
6. Copy the generated password

### Update server.js:

```javascript
// Line 135-139 in server.js
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "your-email@gmail.com",               // ← Your Gmail address
    pass: "xxxx xxxx xxxx xxxx"                 // ← 16-char App Password
  }
});
```

### Test Email:
```bash
curl -X POST http://localhost:3000/test-email \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}'
```

---

## Step 2: Configure Razorpay Payment Gateway

### Prerequisites:
- Razorpay Account (https://razorpay.com)
- API Keys from Razorpay Dashboard

### Get Your Razorpay Keys:

1. Login to https://dashboard.razorpay.com
2. Go to **Settings → API Keys**
3. Copy:
   - **Key ID** (starts with `rzp_live_` or `rzp_test_`)  
   - **Key Secret**

### Update server.js:

```javascript
// Line 152-155 in server.js
const razorpay = new Razorpay({
  key_id: "rzp_test_xxxxxxxx",        // ← Your Razorpay Key ID
  key_secret: "xxxxxxxx"              // ← Your Razorpay Key Secret
});
```

### Update index.html:

```javascript
// Line ~4150 in index.html - within processRazorpayPayment function
const options = {
  key: "rzp_test_xxxxxxxx",           // ← Your Razorpay Key ID (public)
  amount: amount * 100,               // Amount in paise
  currency: "INR",
  // ... rest of config
};
```

### Test Payment:
Use Razorpay Test Card: 
- Card: `4111 1111 1111 1111`
- Expiry: Any future date (e.g., 12/25)
- CVV: Any 3 digits (e.g., 123)

---

## Step 3: Domain Configuration (uaelectronicsindia.com)

### Prerequisites:
- Domain registered (e.g., GoDaddy, Namecheap, Google Domains)
- Hosting server (AWS, DigitalOcean, Heroku, etc.)

### Option A: Using Heroku (Easiest)

1. **Install Heroku CLI**: https://devcenter.heroku.com/articles/heroku-cli
2. **Login**: `heroku login`
3. **Create app**: `heroku create ua-electronics`
4. **Deploy**:
   ```bash
   git push heroku main
   ```
5. **Set Custom Domain**:
   ```bash
   heroku domains:add uaelectronicsindia.com
   ```
6. **Update Domain DNS** (in your domain registrar):
   - Add CNAME record pointing to Heroku dyno

### Option B: Using DigitalOcean

1. Create Droplet (Ubuntu 20.04)
2. SSH into server
3. Clone repository
4. Install Node.js and dependencies
5. Start server with PM2 (process manager)
6. Setup Nginx as reverse proxy
7. Point domain DNS to server IP

### Option C: Using AWS

1. Create EC2 instance
2. Configure security groups
3. Deploy Node.js application
4. Use Route53 for DNS

---

## Step 4: SSL Certificate (HTTPS)

### Using Let's Encrypt (Free):

```bash
# Install Certbot
sudo apt-get install certbot python3-certbot-nginx

# Generate certificate
sudo certbot certonly --standalone -d uaelectronicsindia.com

# Auto-renewal
sudo certbot renew --dry-run
```

### Using Heroku:
- Heroku provides free automatic SSL

---

## Step 5: Database Configuration

### Current Setup: JSON Files
- Orders: `/data/orders.json`
- Products: `/data/products.json`
- Users: `/data/users.json`

### To Upgrade to MongoDB (Recommended):

1. Create MongoDB Atlas account: https://www.mongodb.com/cloud/atlas
2. Create cluster (free tier available)
3. Get connection string
4. Update server.js:

```javascript
const mongoose = require('mongoose');

mongoose.connect(process.env.MONGODB_URI || 'mongodb+srv://user:pass@cluster.mongodb.net/uaelectronics');
```

---

## Step 6: Environment Variables

Create `.env` file in project root:

```env
# Email
GMAIL_USER=your-email@gmail.com
GMAIL_PASS=xxxx xxxx xxxx xxxx

# Payment
RAZORPAY_KEY_ID=rzp_test_xxxxxxxx
RAZORPAY_KEY_SECRET=xxxxxxxx

# Database
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/uaelectronics

# Server
PORT=3000
NODE_ENV=production
DOMAIN=uaelectronicsindia.com
```

Update server.js:
```javascript
require('dotenv').config();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_PASS
  }
});
```

---

## Step 7: Admin Dashboard

Login credentials:
- **Email**: admin@uaelectronics.in
- **Password**: admin123

Features:
- View all orders
- Track revenue
- Manage products
- View customer details

---

## Step 8: Testing Checklist

- [ ] Products display correctly
- [ ] Login/Signup works
- [ ] Add to cart functionality
- [ ] Checkout flow completes
- [ ] Payment gateway shows
- [ ] COD order placement works
- [ ] Online payment simulation works
- [ ] Order email received
- [ ] PDF receipt generated & saved
- [ ] Orders appear in database
- [ ] Admin dashboard loads

---

## Troubleshooting

### Email Not Sending:
- ✓ Check Gmail App Password (not regular password)
- ✓ Verify 2-step verification is enabled
- ✓ Check if "Less Secure Apps" is turned OFF (use App Password instead)
- ✓ Check server logs: `npm start`

### Payment Gateway Not Showing:
- ✓ Verify Razorpay keys in server.js and index.html
- ✓ Check browser console for errors
- ✓ Ensure script loads: `<script src="https://checkout.razorpay.com/v1/checkout.js">`

### PDF Not Generating:
- ✓ Ensure `/Orders` directory exists
- ✓ Check write permissions
- ✓ Check server logs for pdfkit errors

### Orders Not Saving:
- ✓ Verify `/data` directory exists
- ✓ Check firewall rules
- ✓ Check database connection
- ✓ Review server console for errors

---

## Support

For issues, check:
1. Browser Console (F12) for errors
2. Server Console output
3. Network tab in DevTools
4. Application/LocalStorage in DevTools

---

**Last Updated**: April 14, 2026
**Status**: ✅ Ready for Production
