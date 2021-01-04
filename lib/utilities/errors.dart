class AuthError {
  int errorCode;
  String errorMessage;

  AuthError(int errorCode) {
    this.errorCode = errorCode;

    switch (this.errorCode) {
      case 0:
        this.errorMessage = "";
        break;
      case 1:
        this.errorMessage = "Enter E-mail";
        break;
      case 2:
        this.errorMessage = "Enter Password";
        break;
      case 3:
        this.errorMessage = "User Already Exists";
        break;
      case 4:
        this.errorMessage = "Enter Name";
        break;
      case 5:
        this.errorMessage = "No user for the following E-mail";
        break;
      case 6:
        this.errorMessage = 'Cannot save document';
        break;
    }
  }
}