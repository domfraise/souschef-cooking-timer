import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                  "Phraze built the Sous Chef - Cooking Timer app as a Free app. This SERVICE is provided by Phraze at no cost and is intended for use as is. This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service. If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Sous Chef - Cooking Timer unless otherwise defined in this Privacy Policy."),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Information Collection and Use",
                // style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to Device ID. The information that we request will be retained by us and used as described in this privacy policy. ",
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "The app does use third party services that may collect information used to identify you. Link to privacy policy of third party service providers used by the app ",
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Google Play Services",
                      // style: Theme.of(context).textTheme.button.copyWith(
                      //     color: Colors.blue,
                      //     decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://policies.google.com/privacy');
                        },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Firebase Analytics",
                      // style: Theme.of(context).textTheme.button.copyWith(
                      //     color: Colors.blue,
                      //     decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch('https://firebase.google.com/policies/analytics');
                        },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Log Data",
                // style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.",
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Cookies",
                // style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory. This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.",
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Service Providers",
                // style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "We may employ third-party companies and individuals due to the following reasons: To facilitate our Service; To provide the Service on our behalf; To perform Service-related services; or To assist us in analyzing how our Service is used. We want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose. ",
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Security",
                // style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security. ",
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Links to Other Sites",
                // style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services. ",
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Children’s Privacy",
                // style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.",
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Changes to This Privacy Policy",
                // style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.",
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Contact Us",
                // style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at domfraise@gmail.com",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
