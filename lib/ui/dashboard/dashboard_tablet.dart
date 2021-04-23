import 'package:flutter/material.dart';

class DashboardTablet extends StatefulWidget {
  @override
  _DashboardTabletState createState() => _DashboardTabletState();
}

class _DashboardTabletState extends State<DashboardTablet>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  // var isBusy = false;
  // var _projects = <Project>[];
  // var _users = <mon.User>[];
  // var _photos = <Photo>[];
  // var _videos = <Video>[];
  // mon.User _user;
  //
  // @override
  // void initState() {
  //   _controller = AnimationController(vsync: this);
  //   super.initState();
  //   _getAdmin();
  //   _setItems();
  //   _listen();
  // }
  //
  // void _getAdmin() async {
  //   _user = await Prefs.getUser();
  // }
  //
  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }
  //
  // var items = List<BottomNavigationBarItem>();
  // void _setItems() {
  //   items
  //       .add(BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'));
  //   items.add(
  //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Projects'));
  //   items.add(
  //       BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Reports'));
  // }
  //
  // void _refresh(bool forceRefresh) async {
  //   setState(() {
  //     isBusy = true;
  //   });
  //   await monitorBloc.refreshOrgDashboardData(forceRefresh: forceRefresh);
  //   setState(() {
  //     isBusy = false;
  //   });
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       key: _key,
  //       appBar: AppBar(
  //         actions: [
  //           IconButton(
  //               icon: Icon(Icons.credit_card),
  //               onPressed: _navigateToCreditCard),
  //           IconButton(
  //               icon: Icon(Icons.info_outline), onPressed: _navigateToIntro),
  //           IconButton(
  //             icon: Icon(Icons.settings),
  //             onPressed: () {
  //               themeBloc.changeToRandomTheme();
  //             },
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.refresh),
  //             onPressed: () {
  //               _refresh(true);
  //             },
  //           )
  //         ],
  //         bottom: PreferredSize(
  //           preferredSize: Size.fromHeight(120),
  //           child: Column(
  //             children: [
  //               Text(
  //                 widget.user == null ? '' : widget.user.organizationName,
  //                 style: Styles.blackBoldMedium,
  //               ),
  //               SizedBox(
  //                 height: 16,
  //               ),
  //               Text(
  //                 widget.user == null ? '' : widget.user.name,
  //                 style: Styles.whiteSmall,
  //               ),
  //               SizedBox(
  //                 height: 2,
  //               ),
  //               Text(
  //                 'Team Administrator',
  //                 style: Styles.blackTiny,
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       backgroundColor: Colors.brown[100],
  //       bottomNavigationBar: BottomNavigationBar(
  //         items: items,
  //         onTap: _handleBottomNav,
  //       ),
  //       body: isBusy
  //           ? Center(
  //               child: Container(
  //                 height: 48,
  //                 width: 48,
  //                 child: CircularProgressIndicator(
  //                   strokeWidth: 8,
  //                   backgroundColor: Colors.teal,
  //                 ),
  //               ),
  //             )
  //           : Stack(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(12.0),
  //                   child: GridView.count(
  //                     crossAxisCount: 2,
  //                     children: [
  //                       Container(
  //                         child: GestureDetector(
  //                           onTap: _navigateToProjectList,
  //                           child: Card(
  //                             child: Column(
  //                               children: [
  //                                 SizedBox(
  //                                   height: 48,
  //                                 ),
  //                                 StreamBuilder<List<Project>>(
  //                                     stream: monitorBloc.projectStream,
  //                                     builder: (context, snapshot) {
  //                                       if (snapshot.hasData)
  //                                         _projects = snapshot.data;
  //                                       return Text(
  //                                         '${_projects.length}',
  //                                         style: Styles.blackBoldLarge,
  //                                       );
  //                                     }),
  //                                 SizedBox(
  //                                   height: 8,
  //                                 ),
  //                                 Text(
  //                                   'Projects',
  //                                   style: Styles.greyLabelSmall,
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         child: GestureDetector(
  //                           onTap: _navigateToUserList,
  //                           child: Card(
  //                             child: Column(
  //                               children: [
  //                                 SizedBox(
  //                                   height: 48,
  //                                 ),
  //                                 StreamBuilder<List<User>>(
  //                                     stream: monitorBloc.usersStream,
  //                                     builder: (context, snapshot) {
  //                                       if (snapshot.hasData)
  //                                         _users = snapshot.data;
  //                                       return Text(
  //                                         '${_users.length}',
  //                                         style: Styles.blackBoldLarge,
  //                                       );
  //                                     }),
  //                                 SizedBox(
  //                                   height: 8,
  //                                 ),
  //                                 Text(
  //                                   'Users',
  //                                   style: Styles.greyLabelSmall,
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         child: Card(
  //                           child: Column(
  //                             children: [
  //                               SizedBox(
  //                                 height: 48,
  //                               ),
  //                               StreamBuilder<List<Photo>>(
  //                                   stream: monitorBloc.photoStream,
  //                                   builder: (context, snapshot) {
  //                                     if (snapshot.hasData)
  //                                       _photos = snapshot.data;
  //                                     return Text(
  //                                       '${_photos.length}',
  //                                       style: Styles.blackBoldLarge,
  //                                     );
  //                                   }),
  //                               SizedBox(
  //                                 height: 8,
  //                               ),
  //                               Text(
  //                                 'Photos',
  //                                 style: Styles.greyLabelSmall,
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         child: Card(
  //                           child: Column(
  //                             children: [
  //                               SizedBox(
  //                                 height: 48,
  //                               ),
  //                               StreamBuilder<List<Video>>(
  //                                   stream: monitorBloc.videoStream,
  //                                   builder: (context, snapshot) {
  //                                     if (snapshot.hasData)
  //                                       _videos = snapshot.data;
  //                                     return Text(
  //                                       '${_videos.length}',
  //                                       style: Styles.blackBoldLarge,
  //                                     );
  //                                   }),
  //                               SizedBox(
  //                                 height: 8,
  //                               ),
  //                               Text(
  //                                 'Videos',
  //                                 style: Styles.greyLabelSmall,
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //     ),
  //   );
  // }
  //
  // void _handleBottomNav(int value) {
  //   switch (value) {
  //     case 0:
  //       pp(' 🔆🔆🔆 Navigate to MonitorList');
  //       _navigateToUserList();
  //       break;
  //     case 1:
  //       pp(' 🔆🔆🔆 Navigate to ProjectList');
  //       Navigator.push(
  //           context,
  //           PageTransition(
  //               type: PageTransitionType.scale,
  //               alignment: Alignment.topLeft,
  //               duration: Duration(seconds: 1),
  //               child: ProjectListMain(widget.user)));
  //       break;
  //     case 2:
  //       pp(' 🔆🔆🔆 Navigate to MediaList');
  //       _navigateToMediaList();
  //       break;
  //   }
  // }
  //
  // void _navigateToMediaList() {
  //   Navigator.push(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.scale,
  //           alignment: Alignment.topLeft,
  //           duration: Duration(seconds: 1),
  //           child: MediaListMain(null)));
  // }
  //
  // void _navigateToUserList() {
  //   Navigator.push(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.scale,
  //           alignment: Alignment.topLeft,
  //           duration: Duration(seconds: 1),
  //           child: UserListMain()));
  // }
  //
  // void _navigateToProjectList() {
  //   Navigator.push(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.scale,
  //           alignment: Alignment.topLeft,
  //           duration: Duration(seconds: 1),
  //           child: ProjectListMain(widget.user)));
  // }
  //
  // void _navigateToIntro() {
  //   Navigator.push(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.scale,
  //           alignment: Alignment.topLeft,
  //           duration: Duration(seconds: 1),
  //           child: IntroMain(
  //             user: widget.user,
  //           )));
  // }
  //
  // void _navigateToCreditCard() {
  //   Navigator.push(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.scale,
  //           alignment: Alignment.topLeft,
  //           duration: Duration(seconds: 1),
  //           child: CreditCardHandlerMain(
  //             user: widget.user,
  //           )));
  // }
  //
  // void _listen() {
  //   pp('DashboardTablet: 🍎 🍎 _listen to FCM message streams ... 🍎 🍎');
  //   var android = UniversalPlatform.isAndroid;
  //   var ios = UniversalPlatform.isIOS;
  //   if (android || ios) {
  //     fcmBloc.projectStream.listen((Project project) async {
  //       if (mounted) {
  //         pp('DashboardTablet: 🍎 🍎 showProjectSnackbar: ${project.name} ... 🍎 🍎');
  //         _projects = await monitorBloc.getOrganizationProjects(
  //             organizationId: _user.organizationId, forceRefresh: false);
  //         setState(() {});
  //         SpecialSnack.showProjectSnackbar(
  //             scaffoldKey: _key,
  //             textColor: Colors.white,
  //             backgroundColor: Theme.of(context).primaryColor,
  //             project: project,
  //             listener: this);
  //       }
  //     });
  //     fcmBloc.userStream.listen((User user) async {
  //       if (mounted) {
  //         pp('DashboardTablet: 🍎 🍎 showUserSnackbar: ${user.name} ... 🍎 🍎');
  //         _users = await monitorBloc.getOrganizationUsers(
  //             organizationId: _user.organizationId, forceRefresh: false);
  //         setState(() {});
  //         SpecialSnack.showUserSnackbar(
  //             scaffoldKey: _key, user: user, listener: this);
  //       }
  //     });
  //     fcmBloc.photoStream.listen((Photo photo) async {
  //       if (mounted) {
  //         pp('DashboardTablet: 🍎 🍎 showPhotoSnackbar: ${photo.userName} ... 🍎 🍎');
  //         _photos = await monitorBloc.getOrganizationPhotos(
  //             organizationId: _user.organizationId, forceRefresh: false);
  //         setState(() {});
  //         SpecialSnack.showPhotoSnackbar(
  //             scaffoldKey: _key, photo: photo, listener: this);
  //       }
  //     });
  //     fcmBloc.videoStream.listen((Video video) async {
  //       if (mounted) {
  //         pp('DashboardTablet: 🍎 🍎 showVideoSnackbar: ${video.userName} ... 🍎 🍎');
  //         _videos = await monitorBloc.getOrganizationVideos(
  //             organizationId: _user.organizationId, forceRefresh: false);
  //         SpecialSnack.showVideoSnackbar(
  //             scaffoldKey: _key, video: video, listener: this);
  //       }
  //     });
  //     fcmBloc.messageStream.listen((mon.OrgMessage message) {
  //       if (mounted) {
  //         pp('DashboardTablet: 🍎 🍎 showMessageSnackbar: ${message.message} ... 🍎 🍎');
  //
  //         SpecialSnack.showMessageSnackbar(
  //             scaffoldKey: _key, message: message, listener: this);
  //       }
  //     });
  //   } else {
  //     pp('App is running on the Web 👿 👿 👿  firebase messaging is OFF 👿 👿 👿');
  //   }
  // }
  //
  // var _key = GlobalKey<ScaffoldState>();
  // static const BLUE =
  //     '🔵 🔵 🔵 DashboardMain:  🦠  🦠  🦠 FCM message arrived:  🦠 ';
  //
  @override
  onClose() {
    // _key.currentState.removeCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
