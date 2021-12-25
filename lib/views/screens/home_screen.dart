import 'package:chat_app/controllers/rooms_provider.dart';
import 'package:chat_app/models/constants.dart';
import 'package:chat_app/models/room.dart';
import 'package:chat_app/views/screens/create_room.dart';
import 'package:chat_app/views/widgets/rooms_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constants.decoration,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout)),
          title: const Text('Home Screen'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(CreateRoom.routeName);
          },
        ),
        body: StreamBuilder<QuerySnapshot<Room>>(
            stream: Provider.of<RoomsProvider>(context, listen: false)
                .roomsRef
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error has occurred'));
              }
              final rooms = snapshot.data!.docs.map((e) => e.data()).toList();
              final myRooms = rooms
                  .where((room) =>
                      Provider.of<RoomsProvider>(context).joinedTheRoom(room))
                  .toList();
              final browseRooms = rooms
                  .where((room) =>
                      !Provider.of<RoomsProvider>(context).joinedTheRoom(room))
                  .toList();
              return Column(
                children: [
                  TabBar(
                    indicatorColor: Colors.white,
                    controller: tabController,
                    tabs: const [
                      Tab(
                        text: 'My Rooms',
                      ),
                      Tab(
                        text: 'Browse',
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        RoomsGrid(myRooms),
                        RoomsGrid(browseRooms),
                      ],
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
