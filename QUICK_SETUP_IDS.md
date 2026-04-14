# 🔑 QUICK REFERENCE - IDs TO REPLACE

## 🚀 30-SECOND SETUP GUIDE

### **Copy these 4 IDs into your code to activate tracking:**

---

## 1️⃣ GOOGLE ANALYTICS ID

**What:** Measurement ID  
**Format:** `G-XXXXXXXXXX` (starts with "G-")  
**Where to find:**
1. Go to https://analytics.google.com/
2. Sign in with Google account
3. Create new property: "UA Electronics"
4. Go to **Admin** → **Property Settings**
5. Copy "Measurement ID"

**Where to paste in code:**
- [index.html](index.html) Line ~110
- [index.html](index.html) Line ~120

```javascript
// FIND THIS:
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>

// REPLACE WITH:
<script async src="https://www.googletagmanager.com/gtag/js?id=G-YOUR_ACTUAL_ID"></script>

// Also find and replace in gtag config:
gtag('config', 'G-XXXXXXXXXX', { ... });
// TO:
gtag('config', 'G-YOUR_ACTUAL_ID', { ... });
```

**Example:** `G-NPL9H2V5XB`

---

## 2️⃣ META PIXEL ID

**What:** Facebook Pixel ID  
**Format:** 15-digit number (no letters)  
**Where to find:**
1. Go to https://business.facebook.com/
2. Go to **Events Manager**
3. Click **Data Sources** → **Website**
4. Click **Create Pixel** or **Choose Existing**
5. Copy the Pixel ID (15 digits)

**Where to paste in code:**
- [index.html](index.html) Line ~135
- [index.html](index.html) Line ~137

```javascript
// FIND THESE (2 places):
fbq('init', 'YOUR_PIXEL_ID');
// Replace both instances with:
fbq('init', '1234567890123456');

// Also find:
src="https://www.facebook.com/tr?id=YOUR_PIXEL_ID&ev=PageView&noscript=1"
// Replace with:
src="https://www.facebook.com/tr?id=1234567890123456&ev=PageView&noscript=1"
```

**Example:** `1234567890123456`

---

## 3️⃣ & 4️⃣ GOOGLE ADS CONVERSION IDs

**What:** Conversion ID + Label for purchase tracking  
**Format:** 
- ID: `AW-XXXXXXXXX` (starts with "AW-")
- Label: `ABC123DEF456` (alphanumeric)

**Where to find:**
1. Go to https://ads.google.com/
2. Sign in with Google Ads account
3. Go to **Tools** (wrench icon) → **Conversions**
4. Click **+ New Conversion Action**
5. Select **Website** → **Purchase**
6. Fill in:
   - Name: "Purchase"
   - Value: ₹ (auto-filled)
   - Include in "conversions": ✅ Yes
7. Click **Create and Continue**
8. Copy **Conversion ID** (AW-XXXXXXXXX)
9. Scroll down, copy **Conversion Label** (alphanumeric)

**Where to paste in code:**
- [index.html](index.html) Line ~145

```javascript
// FIND THIS:
<script async src="https://www.googletagmanager.com/gtag/js?id=AW-CONVERSION_ID"></script>

// REPLACE WITH (ID only):
<script async src="https://www.googletagmanager.com/gtag/js?id=AW-1234567890"></script>

// ALSO FIND THIS (in the gtag event):
'send_to': 'AW-CONVERSION_ID/CONVERSION_LABEL'

// REPLACE WITH (both IDs):
'send_to': 'AW-1234567890/ABC123DEF456'
```

**Example:**
- ID: `AW-1234567890`
- Label: `ABC123DEF456`

---

## ✅ VERIFICATION CHECKLIST

After replacing IDs:

### **Test Google Analytics**
- [ ] Open your website
- [ ] Go to [Google Analytics](https://analytics.google.com/)
- [ ] Real-time → Overview
- [ ] You should see yourself as active user
- [ ] Shows "1 active user now"

### **Test Meta Pixel**
- [ ] Open your website
- [ ] Go to [Meta Business](https://business.facebook.com/)
- [ ] Events Manager → Test Events
- [ ] Refresh website page
- [ ] You should see **PageView** event
- [ ] Add product to cart
- [ ] You should see **AddToCart** event

### **Test Google Ads Conversion**
- [ ] Open your website
- [ ] Go to [Google Ads](https://ads.google.com/)
- [ ] Tools → Conversions
- [ ] Conversion Tracking Status should be **"Active"** (blue checkmark)
- [ ] Place a test order
- [ ] Check **Conversion Details**
- [ ] Should show your test conversion

---

## 🎯 WHERE EXACTLY TO FIND/REPLACE - LINE BY LINE

### **In index.html - Search for these:**

**#1 - GA ID (appears 2 times):**
```
Search: G-XXXXXXXXXX
Replace: G-YOUR_ACTUAL_ID
Locations: ~Line 110 (script tag) and Line 120 (gtag config)
```

**#2 - Meta Pixel ID (appears 2 times):**
```
Search: YOUR_PIXEL_ID
Replace: 1234567890123456
Locations: ~Line 135 (init) and Line 137 (noscript)
```

**#3 & #4 - Google Ads ID (appears 2 times):**
```
Search: AW-CONVERSION_ID
Replace: AW-1234567890
Location: ~Line 145 (script tag)

Search: AW-CONVERSION_ID/CONVERSION_LABEL
Replace: AW-1234567890/ABC123DEF456
Location: ~Line 150 (gtag send_to)
```

---

## 🔍 USING FIND & REPLACE IN YOUR EDITOR

### **VS Code:**
1. **Ctrl+H** (or Cmd+H on Mac) to open Find & Replace
2. Paste search string from above in "Find"
3. Paste replacement ID in "Replace"
4. Click "Replace All"
5. Save file (Ctrl+S)

### **Example:**
```
Find:    G-XXXXXXXXXX
Replace: G-NPL9H2V5XB
```

---

## 🌐 LIVE CHECKLIST - BEFORE LAUNCHING ADS

- [ ] Website loads without errors
- [ ] GA ID replaced and verified
- [ ] Meta Pixel ID replaced and verified
- [ ] Google Ads Conversion IDs replaced and verified
- [ ] Test events show up in dashboards
- [ ] Purchase tracking working (place test order)
- [ ] No console errors (F12 → Console)
- [ ] All pages load under 3 seconds
- [ ] Mobile responsive (test at 375px width)
- [ ] Forms submit without errors

---

## 📞 NEED HELP FINDING YOUR IDs?

### **Google Analytics:**
- Direct: https://analytics.google.com/ → Admin → Property Settings
- Takes 5 minutes to set up

### **Meta Pixel:**
- Direct: https://business.facebook.com/events-manager
- Takes 5 minutes to set up

### **Google Ads:**
- Direct: https://ads.google.com/ → Tools → Conversions
- Takes 10 minutes to set up

---

## 🚀 AFTER SETUP - WHAT TO EXPECT

**Day 1:**
- Website tracking active
- Data collection begins
- Dashboards show "real-time" visitors

**Week 1:**
- GA shows traffic patterns
- Meta Pixel shows user actions
- Google Ads shows conversion status

**Month 1:**
- Enough data to optimize
- First campaigns performing
- Can see which products sell best

**Month 2+:**
- Scale successful campaigns
- Reduce spending on low performers
- Double revenue (with optimization)

---

## 💡 MOST COMMON MISTAKES

❌ **WRONG:**
```javascript
fbq('init', 'YOUR_PIXEL_ID'); // Left placeholder
gtag('config', 'G-XXXXX'); // Incomplete ID
'send_to': 'AW-123/LAB-456'; // But no conversion label
```

✅ **RIGHT:**
```javascript
fbq('init', '1234567890123456'); // Actual 15-digit ID
gtag('config', 'G-NPL9H2V5XB'); // Actual complete ID
'send_to': 'AW-1234567890/ABC123DEF456'; // Both required
```

---

## ⏱️ TIME ESTIMATE

| Task | Time |
|------|------|
| Find GA ID | 5 min |
| Find Meta Pixel ID | 5 min |
| Find Google Ads IDs | 10 min |
| Replace in code | 5 min |
| Verify in dashboards | 10 min |
| **TOTAL** | **35 min** |

---

**You're all set! Follow the steps above and your tracking will be fully operational.** ✅

For detailed setup guide, see: [SEO_AND_ADS_SETUP.md](SEO_AND_ADS_SETUP.md)

For complete checklist, see: [SEO_IMPLEMENTATION_CHECKLIST.md](SEO_IMPLEMENTATION_CHECKLIST.md)
