enum PagePath {
  viewPage('/'),
  himaList('/hima-list'),
  profile('/profile'),
  signIn('/sign-in'),
  signUp('/sign-up');

  const PagePath(this.path);
  final String path;
}
