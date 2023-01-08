import 'package:catalinadev/services/multivendor_base_api.dart';

// baseurl
String url = "https://desdksamarket.com";

// oauth_consumer_key
String consumerKey = "ck_a791705a953eaec15b890a219dc99bc9f562d358";
String consumerSecret = "cs_b09a15d7298d59fe9bb8f8e5399b6a6ead446200";

// baseApiRequest for Multivendor
MultiVendorBaseAPI baseAPI =
    MultiVendorBaseAPI(url, consumerKey, consumerSecret);

// General Settings Endpoint
String introPage = 'home-api/intro-page';
String generalSetting = 'home-api/general-settings';

// Register Endpoint
String signUpUrl = 'register';

// Auth Endpoint
String loginDefault = 'generate_auth_cookie';
String signInOTP = 'firebase_sms_login';

// Home Endpoint
String homeSlider = 'home-api/slider';
String homeCategory = 'home-api/categories';
String homeMiniBanner = 'home-api/mini-banner';
String extendProducts = 'home-api/extend-products';
String recentProducts = 'home-api/recent-view-products';
String newHomeURL = 'home-api';

// Product Endpoint
String product = 'list-produk';
String attribute = 'wc-attributes-term';
String checkWishlistProduct = 'home-api/check-product-wistlist';
String setWishlistProduct = 'home-api/add-remove-wistlist';
String listWishlistProduct = 'home-api/list-product-wistlist';
String checkVariations = 'home-api/check-produk-variation';
String reviewProductUrl = '$product/reviews';
String getBarcodeUrl = 'get-barcode';
String getFlashSaleURL = 'home-api/flash-sale';
String addReviewUrl = 'products/reviews';
String hitViewedProducts = 'home-api/hit-products';

// Categories
String productCategories = 'products/categories';
String allCategoriesURL = 'get-all-categories';

// Store Endpoint
String allStoreUrl = 'get-vendor-list';
String detailStoreUrl = 'get-vendor-detail';
String uploadImgUrl = 'upload-image';
String inputProductUrl = 'input-produk';
String removeProductUrl = 'delete-produk';
String openCloseStoreURL = 'vendor-submit-open-close-store';

//Attribute Variant Product Endpoint
String attributeUrl = 'wc-attributes-term';

// Vendor
String createUpdateVendorURL = 'create-update-vendor';
String rekeningVendorURL = 'update-payment-vendor';
String vendorRequestListURL = 'vendor-request-withdrawal';
String vendorListHistoryURL = 'vendor-get-history-withdrawal';
String vendorSubmitRequestURL = 'vendor-submit-request-withdrawal';

// Profile Endpoint
String detailProfileUrl = 'get_currentuserinfo';
String updateProfileUrl = 'update_user_profile';

// Order
String orderApi = '/revo-checkout/';
String listOrders = 'home-api/list-orders';
String listOrdersVendorUrl = 'get-orders-vendor-list';
String updateOrderUrl = 'update-status-order';

//Notification
String listNotificationURL = 'home-api/list-notification';
String pushNotificationURL = 'home-api/input-token-firebase';

//Chat
String detailChatURL = 'detail-chat';
String listChatURL = 'list-user-chat';
String insertChatURL = 'insert-chat';

//Shipping
String getEpekenSettingURL = 'vendor-get-shipping-setting';
String submitEpekenKurir = 'vendor-submit-shipping-setting';
String wcShippingSetting = 'wc-shipping-settings';
String wcShippingDetail = 'wc-detail-shipping';
String wcPostShipping = 'wc-addOrRemove-shipping-method';
String wcPostShippingSetting = 'wc-update-shipping-settings';
String wcPostShippingDetail = 'wc-update-shipping-zone-postalcode';
String wcUpdateShippingMethod = 'wc-update-shipping-method';

//Blog
String blogListURL = 'posts';
String listCommentURL = 'comments';
String sendCommentURL = 'post_comment/';
