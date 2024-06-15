import 'package:chatapp/api/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class ChatsController extends GetxController {


  TextEditingController messageController = TextEditingController();
  ScrollController scrollController =  ScrollController();
  RxBool isEmojiPickerVisible = false.obs;

  // final _focusNode = FocusNode();

  Api api = Api();

  RxBool isLoading = false.obs;
  RxBool emojiShowing = false.obs;

  String profileUrl = '';
  void updateProfileUrl(String newUrl) {
    profileUrl = newUrl;
  }

  RxString name="".obs;
  RxString email="".obs;
  RxString photo="".obs;
  RxString receiverId="".obs;
  RxString token="".obs;
  //RxBool status = true.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    name.value = arguments['name'];
    email.value = arguments['email'];
    photo.value = arguments['photo'];
    receiverId.value = arguments['receiverId'];
    token.value = arguments['token'];
    //status.value = arguments['status'];
  }

  // String getTimeDifferenceString(int timestamp) {
  //   DateTime now = DateTime.now();
  //   DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  //
  //   Duration difference = now.difference(dateTime);
  //   if (difference.inSeconds < 60) {
  //     return 'Just now';
  //   } else if (difference.inMinutes < 60) {
  //     return '${difference.inMinutes} min ago';
  //   } else if (difference.inHours < 24) {
  //     return '${difference.inHours} hr ago';
  //   } else if (difference.inDays < 7) {
  //     return '${difference.inDays} days ago';
  //   } else if (difference.inDays < 365) {
  //     DateFormat formatter = DateFormat('E');
  //     String dayOfWeek = formatter.format(dateTime);
  //     return '$dayOfWeek, ${DateFormat('h:mm a').format(dateTime)}';
  //   } else {
  //     DateFormat formatter = DateFormat('MMM d');
  //     return formatter.format(dateTime);
  //   }
  // }

  String getTimeDifferenceString(int timestamp) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    Duration difference = now.difference(dateTime);
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      DateFormat formatter = DateFormat('MMM dd, yyyy');
      return formatter.format(dateTime);
    }
  }






}

