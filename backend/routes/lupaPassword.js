const express = require("express");
const {
	sendOTP,
	verifyOTP
} = require("../services/lupaPassword");

const router = express.Router();

router.post("/send-otp", async (req, res) => {
	const {
		email
	} = req.body;
	try {
		const message = await sendOTP(email);
		res.json({
			message
		});
	} catch (error) {
		res.status(400).json({
			message: error.message
		});
	}
});

router.post("/verify-otp", (req, res) => {
	const {
		email,
		otp
	} = req.body;
	try {
		const result = verifyOTP(email, otp);

		if (result === "expired") {
			return res.status(401).json({
				message: "expired"
			}); // Status 401 untuk expired
		}

		res.json({
			message: "OTP valid, lanjutkan reset password!",
			token: result
		});
	} catch (error) {
		res.status(400).json({
			message: error.message
		});
	}
});


module.exports = router;