var CryptoUtil = {};
var aesivstr = "";

CryptoUtil.toHex = function (s) {
	var hex = "";
	for (var i = 0; i < s.length; i++) {
		hex += "" + s.charCodeAt(i).toString(16);
	}
	return hex;
}

CryptoUtil.aes = function (s, k, t) {
	var key = CryptoJS.enc.Hex.parse(k);
	var iv = CryptoJS.enc.Hex.parse(CryptoUtil.toHex(aesivstr));
	var processed = "";

	if (t == "encrypt") {
		processed = CryptoJS.AES.encrypt(s, key, {iv: iv});
	} else if (t == "decrypt") {
		var decrypted = CryptoJS.AES.decrypt(s, key, {iv: iv});
		processed = decrypted.toString(CryptoJS.enc.Utf8);
	} else {
		alert("not supported AES type...");
	}

	return processed;
}

CryptoUtil.aes128 = function (s, t) {
	// t: "encrypt", "decrypt"
	// k: 16자리 (128bit)
	var k = "7468696e6b6d6973746865626573746d";
	return CryptoUtil.aes(s, k, t);
}

CryptoUtil.aes256 = function (s, t) {
	// t: "encrypt", "decrypt"
	// k: 32자리 (256bit)
	var k = "7468696e6b6d6973746865626573746d6f62696c65736f6c7574696f6e636f6d";
	return CryptoUtil.aes(s, k, t);
}

CryptoUtil.aesEncrypt = function (s, k) {
	// k: 16자리 (128bit), 32자리 (256bit)
	var key = CryptoUtil.toHex(k);
	return CryptoUtil.aes(s, key, "encrypt");
}

CryptoUtil.aesDecrypt = function (s, k) {
	// k: 16자리 (128bit), 32자리 (256bit)
	var key = CryptoUtil.toHex(k);
	return CryptoUtil.aes(s, key, "decrypt");
}
