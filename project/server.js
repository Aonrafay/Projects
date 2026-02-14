const express = require('express');
const nodemailer = require('nodemailer');
const bodyParser = require('body-parser');
const app = express();

// 1. Dynamic Port Selection (Required for hosting)
const PORT = process.env.PORT || 10000;

// Middleware to handle form data
app.use(bodyParser.urlencoded({ extended: true }));

// Setup the Email Transporter
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'aonrafay@gmail.com', 
    pass: 'uoma kpcw yapd ldfc' // Using your App Password
  }
});

app.post('/book-appointment', (req, res) => {
  const { name, phone, service, date, time, message } = req.body;

  const mailOptions = {
    from: 'aonrafay@gmail.com', // Best practice: Use the same email as 'user' above
    to: 'mianmusmang@gmail.com',
    subject: `New Appointment Request: ${name}`,
    html: `
      <h2>New Booking Details</h2>
      <p><strong>Patient Name:</strong> ${name}</p>
      <p><strong>Phone:</strong> ${phone}</p>
      <p><strong>Service:</strong> ${service}</p>
      <p><strong>Preferred Date:</strong> ${date}</p>
      <p><strong>Time Slot:</strong> ${time}</p>
      <p><strong>Message:</strong> ${message}</p>
    `
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.log(error);
      return res.status(500).send("Error sending request. Please try again.");
    }
    res.send("<h1>Booking Successful!</h1><p>Dr. Usman's team will contact you soon.</p>");
  });
});

// 2. Updated Listen Command
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});