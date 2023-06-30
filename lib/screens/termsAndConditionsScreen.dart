import 'package:flutter/material.dart';

import '../widgets/bottomWidget.dart';
import '../widgets/navigationBar.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Text(
                        'TERMS AND CONDITIONS',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset("assets/images/1.png", height: 130,),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Welcome to our app. Please read these terms and conditions carefully before using our app.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Introduction',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'These terms and conditions govern your use of our app. By using our app, you agree to these terms and conditions in full. If you disagree with these terms and conditions or any part of these terms and conditions, you must not use our app.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'License to use app',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'Unless otherwise stated, we or our licensors own the intellectual property rights in the app and material on the app. Subject to the license below, all these intellectual property rights are reserved.\nYou may view, download for caching purposes only, and print pages from the app for your own personal use, subject to the restrictions set out below and elsewhere in these terms and conditions.\n\nYou must not:\n\ta. republish material from this app (including republication on another app);\n\tb. sell, rent, or sub-license material from the app;\n\tc. show any material from the app in public;\n\td. reproduce, duplicate, copy or otherwise exploit material on our app for a commercial purpose;\n\te. edit or otherwise modify any material on the app; or\n\tf. redistribute material from this app except for content specifically and expressly made available for redistribution.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Acceptable use',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'You must not use our app in any way that causes, or may cause, damage to the app or impairment of the availability or accessibility of the app; or in any way which is unlawful, illegal, fraudulent or harmful, or in connection with any unlawful, illegal, fraudulent or harmful purpose or activity.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'No warranty',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'This app is provided "as is" without any representations or warranties, express or implied. We make no representations or warranties in relation to this app or the information and materials provided on this app. Nothing in this section will limit or exclude any warranty implied by law that it would be unlawful to limit or exclude.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Limitations of liability',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'We will not be liable to you (whether under the law of contact, the law of torts or otherwise) in relation to the contents of, or use of, or otherwise in connection with, this app:\n\ta. for any indirect, special or consequential loss; or\n\tb. for any business losses, loss of revenue, income, profits or anticipated savings, loss of contracts or business relationships, loss of reputation or goodwill, or loss or corruption of information or data.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    'Indemnity',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'You agree to indemnify us, and our employees and agents, from any claims, demands, losses, liabilities, costs and expenses (including reasonable attorney fees) arising out of or in connection with your use of the app, any breach by you of these terms and conditions, or your violation of any law or the rights of any third party.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    'Variation',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'We may revise these terms and conditions from time-to-time. The revised terms and conditions shall apply to the use of our app from the date of publication of the revised terms and conditions on our app.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    'Assignment',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'We may transfer, sub-contract or otherwise deal with our rights and/or obligations under these terms and conditions without notifying you or obtaining your consent. You may not transfer, sub-contract or otherwise deal with your rights and/or obligations under these terms and conditions.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    'Entire agreement',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'These terms and conditions, together with our privacy policy, constitute the entire agreement between you and us in relation to your use of our app, and supersede all previous agreements in respect of your use of our app. \n\n1.2 By downloading, accessing, or using our app, you agree to be bound by these Terms of Use. If you do not agree to be bound by these Terms of Use, do not download, access, or use our app.\n\n1.3 We may modify these Terms of Use at any time, and such modifications shall be effective immediately upon posting of the modified Terms of Use on our app. You agree to review these Terms of Use periodically to be aware of any modifications. Your continued use of our app after any modifications indicates your acceptance of the modified Terms of Use.\n\n1.4 We reserve the right to modify, suspend, or discontinue all or any aspect of our app at any time without notice.\n\nUse of Our App\n\n2.1 Our app is intended for your personal, non-commercial use only.\n\n2.2 You may use our app only for lawful purposes and in accordance with these Terms of Use. You agree not to use our app:\n\n(a) In any way that violates any applicable federal, state, local, or international law or regulation (including, without limitation, any laws regarding the export of data or software to and from the US or other countries).\n\n(b) To transmit, or procure the sending of, any advertising or promotional material, including any "junk mail," "chain letter," "spam," or any other similar solicitation.\n\n(c) To impersonate or attempt to impersonate us, one of our employees, another user, or any other person or entity (including, without limitation, by using e-mail addresses or screen names associated with any of the foregoing).\n\n(d) To engage in any other conduct that restricts or inhibits anyone\'s use or enjoyment of our app, or which, as determined by us, may harm us or users of our app or expose them to liability.\n\n(e) Use our app in any manner that could disable, overburden, damage, or impair our app or interfere with any other party\'s use of our app, including their ability to engage in real-time activities through our app.\n\n2.3 You may not attempt to gain unauthorized access to our app, other users\' accounts, or any of our servers, computers, or databases.\n\n2.4 We reserve the right to terminate your use of our app for any reason or no reason, without notice.\n\nUser Content\n\n3.1 Our app may allow you to submit, upload, publish, or otherwise make available content, including but not limited to text, photographs, videos, and audio (collectively, "User Content").\n\n3.2 You retain all rights in, and are solely responsible for, the User Content you make available through our app.\n\n3.3 By making User Content available through our app, you grant us a non-exclusive, transferable, sub-licensable, royalty-free, worldwide license to use, copy, modify, create derivative works based on, distribute, publicly display, publicly perform, and otherwise exploit in any manner such User Content in all formats and distribution channels now known or hereafter devised (including in connection with our app and our business and on third-party sites and services), without further notice to or consent from you, and without the requirement of payment to you or any other person or entity.\n\n3.4 You represent and warrant that:\n\n(a) You either are the sole and exclusive owner of all User Content or you have all rights, licenses, consents, and releases that are necessary to grant to us the rights in such User Content, as contemplated under these Terms of Use.\n\n(b) Neither the User Content, nor your submission, uploading, publishing, or otherwise making available of such User Content, nor our use of the User Content as permitted herein will infringe, misappropriate, or violate a third party\'s patent, copyright, trademark, trade secret, moral rights, or other proprietary or intellectual property rights, or rights of publicity or privacy, or result in the violation of any applicable law or regulation.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    'User Conduct',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'By accessing or using our app, you agree that you will not engage in any activity that interferes with or disrupts the app (or the servers and networks which are connected to the app).\nYou agree that you are solely responsible for (and that we have no responsibility to you or to any third party for) any breach of your obligations under these Terms and Conditions and for the consequences of any such breach.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    'Indemnification',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'You agree to indemnify and hold us harmless from and against any claims, actions, suits, or proceedings, as well as any and all losses, liabilities, damages, costs, and expenses (including reasonable attorneys\' fees) arising out of or relating to your use of our app, including, but not limited to, any breach by you of these Terms and Conditions.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    'Disclaimer of Warranties',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'We make no representations or warranties of any kind, express or implied, as to the operation of our app or the information, content, materials, or products included on our app. You expressly agree that your use of our app is at your sole risk.\nTo the full extent permissible by applicable law, we disclaim all warranties, express or implied, including, but not limited to, implied warranties of merchantability and fitness for a particular purpose. We do not warrant that our app, its servers, or email sent from us are free of viruses or other harmful components.\nWe will not be liable for any damages of any kind arising from the use of our app, including, but not limited to direct, indirect, incidental, punitive, and consequential damages.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    'Limitation of Liability',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'To the extent permitted by applicable law, we shall not be liable for any damages arising out of or in connection with your use of our app or these Terms and Conditions, whether such damages are direct, indirect, incidental, consequential, or punitive.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    'Governing Law and Jurisdiction',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'These Terms and Conditions shall be governed by and construed in accordance with the laws of the state of California, without giving effect to any principles of conflicts of law.\nAny legal action or proceeding relating to your access to, or use of, our app or these Terms and Conditions shall be instituted exclusively in the federal or state courts located in the state of California, and you agree to submit to the personal jurisdiction of such courts.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    'Changes to These Terms and Conditions',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'We reserve the right to update or modify these Terms and Conditions at any time and without prior notice. Your use of our app following any such change constitutes your agreement to follow and be bound by the Terms and Conditions as modified.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'If you have any questions about these Terms and Conditions, please contact us at maharanibakery@gmail.com',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 100.0),

                ],


              ),
            ),
          ),
          NavigationsBar(idScreen: "privacy"),

        ],
      ),
    );
  }
}