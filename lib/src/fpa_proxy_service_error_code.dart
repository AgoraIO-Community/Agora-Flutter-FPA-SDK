abstract class FpaProxyServiceErrorCode {
  /**
   * 0: No error occurs.
   */
  static const int none = 0;
  /**
   * A general error occurs (no specified reason).
   */
  static const int failed = -10001;
  /**
   * The SDK module is not ready. Choose one of the following solutions:
   */
  static const int notReady = -10002;
  /**
   * The SDK does not support this function.
   */
  static const int notSupported = -10003;
  /**
   * The request is rejected.
   */
  static const int refused = -10004;
  /**
   * The buffer size is not big enough to store the returned data.
   */
  static const int bufferTooSmall = -10005;
  /**
   * The state is invalid.
   */
  static const int invalidState = -10006;

  static const int timedout = -10007;

  static const int tooOften = -10008;

  static const int invalidArgument = -10009;

  static const int notInitialized = -10010;

  static const int noPermission = -10011;
  /**
   * Local server initialize failed.
   */
  static const int serviceStartFailed = -10012;
  /**
   * Failed to bind port
   */
  static const int bindPortFailed = -10013;
  /**
   * Unable to get available port.
   */
  static const int badPort = -10014;
  /**
   * bad file descriptor
   */
  static const int badFd = -10015;
  /**
   * connect err
   */
  static const int connect = -10016;
  /**
   * send err
   */
  static const int send = -10017;
  /**
   * read err
   */
  static const int read = -10018;
  /**
   * can't find chain id
   */
  static const int noChain = -10019;
}
