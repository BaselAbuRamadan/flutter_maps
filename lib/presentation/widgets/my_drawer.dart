import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/buisness_logic/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/constants/strings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../constants/my_colors.dart';


class MyDrawer extends StatelessWidget {
   MyDrawer({Key? key}) : super(key: key);
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();
   final Uri _url = Uri.parse('https://www.facebook.com/basel.aburamadan');
   final Uri _url2 = Uri.parse('https://github.com/BaselAbuRamadan');
   final Uri _url3 = Uri.parse('https://t.me/BaselAr');

  Widget buildDrawerHeader(context){
    return Column(
      children: [
        Container(
          padding : EdgeInsetsDirectional.fromSTEB(
             70 , 10, 70, 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue[100]
          ),
          child: Image.asset(
              "assets/images/baselcv.jpg",
          fit: BoxFit.cover,
          ),
        ),
        Text('Basel Aburamdan',
        style: TextStyle (fontSize: 20,fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        BlocProvider<PhoneAuthCubit>(
            create:(context) => phoneAuthCubit,
          child: Text(
            '${phoneAuthCubit.getLoggedInUser().phoneNumber}'
            ,style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],

    );
  }
  Widget buildDrawerListItem(
      {required IconData leadingIcon,
        required String title,
        Widget? trailing,
        Function()? onTap,
        Color? color}) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: color ?? MyColors.blue,
      ),
      title: Text(title),
      trailing: trailing ??= Icon(
        Icons.arrow_right,
        color: MyColors.blue,
      ),
      onTap: onTap,
    );
  }

  Widget buildDrawerListItemsDivider() {
    return Divider(
      height: 0,
      thickness: 1,
      indent: 18,
      endIndent: 24,
    );
  }
   Future<void> _launchURLApp() async {
     if (await canLaunchUrl(_url)) {
       await launchUrl(_url
           ,mode:LaunchMode.externalApplication );

     }else{ throw 'Could not launch $_url';}
   }
   Future<void> _launchURLApp2() async {
     if (await canLaunchUrl(_url2)) {
       await launchUrl(_url2
           ,mode:LaunchMode.externalApplication );

     }else{ throw 'Could not launch $_url2';}
   }
   Future<void> _launchURLApp3() async {
     if (await canLaunchUrl(_url3)) {
       await launchUrl(_url3
           ,mode:LaunchMode.externalApplication );

     }else{ throw 'Could not launch $_url3';}
   }
   // Future<void> _launchInBrowser(String url) async {
   //   if (!await  launch(
   //     url,
   //   )) {
   //     throw 'Could not launch $url';
   //   }
   // }
  Widget buildIcon(IconData icon, String url) {
    return InkWell(
      onTap: () => _launchURLApp(),
      child: Icon(icon,
        color: MyColors.blue,
        size: 35,
      ),
    );
  }Widget buildIcon2(IconData icon, String url) {
    return InkWell(
      onTap: () => _launchURLApp2(),
      child: Icon(icon,
        color: MyColors.blue,
        size: 35,
      ),
    );
  }Widget buildIcon3(IconData icon, String url) {
    return InkWell(
      onTap: () => _launchURLApp3(),
      child: Icon(icon,
        color: MyColors.blue,
        size: 35,
      ),
    );
  }


    Widget buildSocialMediaIcons() {
      return Padding(
        padding: const EdgeInsetsDirectional.only(start: 16),
        child: Row(
          children: [
            buildIcon(
              FontAwesomeIcons.facebook,
              '',
            ),
            const SizedBox(
              width: 15,
            ),
            buildIcon3(
              FontAwesomeIcons.telegram,
              '',
            ),
            const SizedBox(
              width: 20,
            ),
            buildIcon2(
              FontAwesomeIcons.github,
              '',
            ),
          ],
        ),
      );
    }
   Widget buildLogoutBlocProvider(context) {
     return Container(
       child: BlocProvider<PhoneAuthCubit>(
         create: (context) => phoneAuthCubit,
         child: buildDrawerListItem(
           leadingIcon: Icons.logout,
           title: 'Logout',
           onTap: () async {
             await phoneAuthCubit.logOut();
             Navigator.of(context).pushReplacementNamed(loginScreen);
           },
           color: Colors.red,
           trailing: SizedBox(),
         ),
       ),
     );
   }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 320,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[100]),
              child: buildDrawerHeader(context),
            ),
          ),
          buildDrawerListItem(leadingIcon: Icons.person, title: 'My Profile'),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.history,
            title: 'Places History',
            onTap: () {},
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(leadingIcon: Icons.settings, title: 'Settings'),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(leadingIcon: Icons.help, title: 'Help'),
          buildDrawerListItemsDivider(),
          buildLogoutBlocProvider(context),
          const SizedBox(
            height: 120,
          ),
          ListTile(
            leading: Text(
              'Follow us',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          buildSocialMediaIcons(),
        ],
      ),
    );
  }

}




