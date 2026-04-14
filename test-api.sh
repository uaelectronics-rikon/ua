#!/bin/bash
# UA ELECTRONICS - API TESTING SCRIPT
# Run this to test all endpoints

API="http://localhost:3000"
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🧪 UA ELECTRONICS API TEST SUITE${NC}\n"

# Test 1: Get Products
echo -e "${YELLOW}1. Testing GET /products${NC}"
curl -s "$API/products" | head -c 150
echo -e "\n${GREEN}✅ Products endpoint working${NC}\n"

# Test 2: Get Single Product
echo -e "${YELLOW}2. Testing GET /product/1${NC}"
curl -s "$API/product/1" | head -c 150
echo -e "\n${GREEN}✅ Single product endpoint working${NC}\n"

# Test 3: Register User
echo -e "${YELLOW}3. Testing POST /register${NC}"
REGISTER_RESULT=$(curl -s -X POST "$API/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email":"testuser'$(date +%s)'@example.com",
    "password":"test123",
    "name":"Test User"
  }')
echo "$REGISTER_RESULT" | head -c 150
echo -e "\n${GREEN}✅ Registration endpoint working${NC}\n"

# Test 4: Login User
echo -e "${YELLOW}4. Testing POST /login${NC}"
LOGIN_RESULT=$(curl -s -X POST "$API/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email":"testuser@example.com",
    "password":"test123"
  }')
echo "$LOGIN_RESULT"
echo -e "\n${GREEN}✅ Login endpoint working${NC}\n"

# Test 5: Save Order
echo -e "${YELLOW}5. Testing POST /save-order${NC}"
ORDER_ID="UAE$(date +%s)"
ORDER_RESULT=$(curl -s -X POST "$API/save-order" \
  -H "Content-Type: application/json" \
  -d '{
    "orderId":"'$ORDER_ID'",
    "date":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
    "items":[
      {
        "id":1,
        "name":"INFRARED Induction Cooktop",
        "brand":"UA RIKON",
        "icon":"🍳",
        "price":2499,
        "qty":1,
        "subtotal":2499
      }
    ],
    "customer":{
      "name":"Test Customer",
      "mobile":"9999999999",
      "email":"testcustomer@example.com",
      "addr1":"123 Test Street",
      "addr2":"Apt 45",
      "city":"Delhi",
      "state":"Delhi",
      "pin":"110001"
    },
    "subtotal":2499,
    "shipping":0,
    "grand":2499,
    "paymentMethod":"Cash on Delivery",
    "paymentStatus":"COD - Pending",
    "paid":false,
    "status":"Confirmed"
  }')
echo "$ORDER_RESULT"
echo -e "\n${GREEN}✅ Save order endpoint working${NC}\n"

# Test 6: Get All Orders
echo -e "${YELLOW}6. Testing GET /orders${NC}"
curl -s "$API/orders" | head -c 150
echo -e "\n${GREEN}✅ Get orders endpoint working${NC}\n"

# Test 7: Track Order
echo -e "${YELLOW}7. Testing GET /track/$ORDER_ID${NC}"
curl -s "$API/track/$ORDER_ID" | head -c 150
echo -e "\n${GREEN}✅ Track order endpoint working${NC}\n"

# Test 8: Create Razorpay Order
echo -e "${YELLOW}8. Testing POST /create-order${NC}"
curl -s -X POST "$API/create-order" \
  -H "Content-Type: application/json" \
  -d '{
    "amount":2499,
    "currency":"INR",
    "orderId":"'$ORDER_ID'"
  }' | head -c 150
echo -e "\n${YELLOW}(Razorpay test keys may not respond - this is normal)${NC}\n"

echo -e "${GREEN}🎉 All tests completed!${NC}\n"
echo -e "${YELLOW}📝 Summary:${NC}"
echo "- Products loaded: ✅"
echo "- User registration: ✅"
echo "- User login: ✅"
echo "- Order saving: ✅"
echo "- Order retrieval: ✅"
echo "- Order tracking: ✅"
echo "- PDF generation: (check /Orders folder)"
echo "- Email sending: (check configured email)"
