import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(
      {required this.stateMachineName,
      required this.artboard,
      required this.src,
      required this.title,
      this.input});
  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAsset> sideMenus = [
  RiveAsset(
      stateMachineName: 'HOME_interactivity',
      artboard: 'HOME',
      src: 'assets/icons/home.riv',
      title: 'Trang chính'),
  RiveAsset(
      stateMachineName: 'STAR_Interactivity',
      artboard: 'LIKE/STAR',
      src: 'assets/icons/home.riv',
      title: 'Biểu đồ'),
  RiveAsset(
      stateMachineName: 'SEARCH_Interactivity',
      artboard: 'SEARCH',
      src: 'assets/icons/home.riv',
      title: 'Tìm kiếm'),
  RiveAsset(
      stateMachineName: 'BELL_Interactivity',
      artboard: 'BELL',
      src: 'assets/icons/home.riv',
      title: 'Nhắc nhở'),
  RiveAsset(
      stateMachineName: 'CHAT_Interactivity',
      artboard: 'CHAT',
      src: 'assets/icons/home.riv',
      title: 'Trợ giúp'),
  RiveAsset(
      stateMachineName: 'RELOAD_Interactivity',
      artboard: 'REFRESH/RELOAD',
      src: 'assets/icons/home.riv',
      title: 'Đăng xuất'),
];
