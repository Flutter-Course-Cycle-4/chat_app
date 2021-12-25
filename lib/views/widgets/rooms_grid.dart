//import 'package:chat_app/controllers/rooms_provider.dart';
import 'package:chat_app/controllers/rooms_provider.dart';
import 'package:chat_app/models/constants.dart';
import 'package:chat_app/models/room.dart';
import 'package:chat_app/views/screens/chat_screen.dart';
//import 'package:chat_app/views/screens/chat_screen.dart';
import 'package:chat_app/views/screens/join_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomsGrid extends StatelessWidget {
  final List<Room> rooms;
  const RoomsGrid(this.rooms, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 9 / 10,
      ),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (!Provider.of<RoomsProvider>(context, listen: false)
                .joinedTheRoom(rooms[index])) {
              Navigator.of(context)
                  .pushNamed(JoinRoomScreen.routeName, arguments: rooms[index]);
            } else {
              Navigator.of(context)
                  .pushNamed(ChatScreen.routeName, arguments: rooms[index]);
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Constants.getCategoryImage(
                              rooms[index].data.category),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        rooms[index].data.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '${rooms[index].data.users.length} member${rooms[index].data.users.length > 1 ? 's' : ''}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
