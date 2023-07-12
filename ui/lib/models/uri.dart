const baseUri = 'http://10.0.2.2:8000/api';

// ----------------------------------------
// account routes

// request method post
const registerUri = "$baseUri/register";

// request method post
const loginUri = "$baseUri/login";

// request method post
const logoutUri = "$baseUri/logout";
// account routes

// ---------------------------------------

// email otp verification routes

// request method post
const emailOtpGen = "$baseUri/email/otp";
// request method post
const verifyOtp = "$baseUri/email/verify";
// email otp verification routes

// ---------------------------------------

// profile routes
const profileUriBase = "$baseUri/profiles";

// request method get
const profileUriIndex = "$profileUriBase/";

// request method post
const profileUriStore = "$profileUriBase/store";

// request method get
const profileUriShow = "$profileUriBase/show";

// request method put
const profileUriUpdate = "$profileUriBase/update";

// request method delete
const profileUriDelete = "$profileUriBase/delete";

// request method get and put
const profileUriUserOnlineStatus = "$profileUriBase/online-status";
// profile routes

// ------------------------------------------

// profile visibility routes
const profileUriVisibility = "$profileUriBase/visibility";

// request method get
const profileUriVisibilityGet = "$profileUriVisibility/get";
// profile visibility routes

// ---------------------------------------------

// chat routes
const chatsUriBase = "$baseUri/chats";

// request method post
const chatsUriReadMessage = "$chatsUriBase/read-message";

// request method post
const chatsUriSendMessage = "$chatsUriBase/send-message";
// chat routes

// -----------------------------------------------