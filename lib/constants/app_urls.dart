class AppUrls {
  static const _baseUrl = "https://api.theleaderboard.site/api/v1";
  // static const _baseUrl = "http://10.10.7.112:5000/api/v1";

  // static const mainUrl = "http://10.10.7.112:5000";
  static const mainUrl = "https://api.theleaderboard.site";

  static const profile = "$_baseUrl/users/me";
  static const login = "$_baseUrl/auth/login";
  static const createUser = "$_baseUrl/users/create-user";
  static const registerUser = "$_baseUrl/auth/register";
  static const resentOtp = "$_baseUrl/auth/otp-resend";
  static const forgetPassword = "$_baseUrl/auth/forget-password";
  static const setNewPassword = "$_baseUrl/auth/reset-password";
  static const verifyOtp = "$_baseUrl/auth/otp-compare";
  static const faq = "$_baseUrl/about/faq";
  static const termAndCondition = "$_baseUrl/about/tac";
  static const reportProblem = "$_baseUrl/about/report";
  static const updateUser = "$_baseUrl/users";
  static const changePassword = "$_baseUrl/auth/change-password";
  static const deleteUser = "$_baseUrl/users";
  static const notification = "$_baseUrl/notifications";
  static const mostViewed = "$_baseUrl/fame/most-viewed";
  static const highestInvestor = "$_baseUrl/fame/highest-investor";
  static const consecutiveToper = "$_baseUrl/fame/consecutively-toper";
  static const currentRuffle = "$_baseUrl/ruffles/current";
  static const myTicket = "$_baseUrl/ruffles/my-tickets";
  static const createTicket = "$_baseUrl/ruffles/ticket";
  static const updateImage = "$_baseUrl/users/update-profileImg";
  static const leaderBoardData = "$_baseUrl/rank";
  static const withdrawAmount = "$_baseUrl/payments/withdraw";
  static const socketUrl = mainUrl;
  static const otherUserProfile = "$_baseUrl/users/detailes";
  static const joinLeaderboard = "$_baseUrl/payments/chekout";
  static const instagramUrl = "https://www.instagram.com/accounts/login/?hl=en";
  static const facebookUrl = "https://www.facebook.com/";
  static const twitterUrl = "https://x.com/i/flow/login";
  static const discordUrl =
      "https://discord.com/login?redirect_to=%2Fchannels%2F%40me";
  static const linkedinUrl = "https://www.linkedin.com/login";
  static const youtubeUrl = "https://www.youtube.com/";
  static const creatorLeaderboard = "$_baseUrl/rank/raised";
  static const countryLeaderboard = "$_baseUrl/rank/country";
  static const refundPolicy = "$_baseUrl/about/return-policy";
  static const privacyPolicy = "$_baseUrl/about/privacy-policy";
  static const raffleRules = "$_baseUrl/about/rules";
  static const rankDaily = "$_baseUrl/rank/today";
  static const rankMonthly = "$_baseUrl/rank/monthly";
  static const raisedDaily = "$_baseUrl/rank/raised/today";
  static const raisedMonthly = "$_baseUrl/rank/raised/monthly";
  static const countryDaily = "$_baseUrl/rank/country/today";
  static const countryMonthly = "$_baseUrl/rank/country/monthly";
}
