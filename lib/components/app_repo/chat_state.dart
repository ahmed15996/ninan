import 'package:flutter/material.dart';
import 'package:ninan/models/chat_msg_between_members.dart';

import 'package:ninan/models/user.dart';
import 'package:ninan/services/access_api.dart';
import 'package:ninan/components/app_repo/app_state.dart';
import 'package:ninan/utils/utils.dart';


class ChatState extends ChangeNotifier{
  User _currentUser;
  String _currentLang;

  void update(AppState appState) {
    _currentUser = appState.currentUser;
    _currentLang = appState.currentLang;
  }

  Services _services = Services();


  Future<List<ChatMsgBetweenMembers>> getChatMessageList(String senderId,String adsId,String userId) async {
    final response = await _services.get(Utils.BETWEEN_MESSAGES_URL +
        '?user_id=$userId&user_id1=$senderId&ads_id=$adsId&page=1&api_lang=$_currentLang');
    List<ChatMsgBetweenMembers> messageList = List<ChatMsgBetweenMembers>();
    if (response['response'] == '1') {
      Iterable iterable = response['messages'];
      messageList = iterable.map((model) => ChatMsgBetweenMembers.fromJson(model)).toList();
    }

    return messageList;
  }

  bool _isLoading = false;  
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  } 
   bool get isLoading => _isLoading;

}