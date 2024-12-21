enum PagePath {
  viewPage('/'),
  himaList('/hima-list'),
  plan('/plan'),
  friend('/friend'),
  profile('/profile'),
  signIn('/sign-in'),
  signUp('/sign-up');

  const PagePath(this.path);
  final String path;
}
