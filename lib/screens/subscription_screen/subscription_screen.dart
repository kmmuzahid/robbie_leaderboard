import 'package:flutter/material.dart';
import 'package:the_leaderboard/utils/revenue_cat_util.dart' as revenue_cat;

class SubscriptionViewWidget extends StatefulWidget {
  const SubscriptionViewWidget({super.key});

  @override
  State<SubscriptionViewWidget> createState() => _SubscriptionViewWidgetState();
}

class _SubscriptionViewWidgetState extends State<SubscriptionViewWidget> {
  bool? purchaseOutput;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          automaticallyImplyLeading: false,
          // leading: FlutterFlowIconButton(
          //   borderColor: Colors.transparent,
          //   borderRadius: 30.0,
          //   borderWidth: 1.0,
          //   buttonSize: 60.0,
          //   icon: const Icon(
          //     Icons.arrow_back_ios_new_rounded,
          //     color: Color(0xFFFFFFFF),
          //     size: 30.0,
          //   ),
          //   onPressed: () async {
          //     context.pop();
          //   },
          // ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: Text(
                    'Subscribe to Premium Plan',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 32.0),
                  child: Text(
                    'Select one of the following Premium plans for unlimited access to all videos, then press the continue button',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0x08000000),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: const Color(0xFF7426EF),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                        child: Icon(
                          Icons.add,
                          color: Color(0xFFF3B22C),
                          size: 64.0,
                        ),
                      ),
                      Text(
                        revenue_cat
                            .offerings!.current!.lifetime!.storeProduct.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.0,
                          color: Color(0xFFA9AAAC),
                        ),
                      ),
                      Text(
                        '${revenue_cat.offerings!.current!.lifetime!.storeProduct.priceString}\$9.9 per month',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.0,
                          color: Color(0xFFA9AAAC),
                        ),
                      ),
                      const Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Icon(
                            Icons.add,
                            color: Color(0xFFF3B22C),
                          ),
                          title: Text(
                            'High quality',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                              color: Color(0xFFA9AAAC),
                            ),
                          ),
                          subtitle: Text(
                            'HD quality (1080p) streaming',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                              color: Color(0xFFA9AAAC),
                            ),
                          ),
                          tileColor: Colors.transparent,
                          dense: false,
                        ),
                      ),
                      const Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Icon(
                            Icons.add,
                            color: Color(0xFFF3B22C),
                          ),
                          title: Text(
                            'Full Access',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                              color: Color(0xFFA9AAAC),
                            ),
                          ),
                          subtitle: Text(
                            'Full access to all Pataka Play  Series',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                              color: Color(0xFFA9AAAC),
                            ),
                          ),
                          tileColor: Colors.transparent,
                          dense: false,
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            leading: Icon(
                              Icons.add,
                              color: Color(0xFFF3B22C),
                            ),
                            title: Text(
                              'Ad-free streaming',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.0,
                                color: Color(0xFFA9AAAC),
                              ),
                            ),
                            subtitle: Text(
                              'Enjoy Ad-free experience',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.0,
                                color: Color(0xFFA9AAAC),
                              ),
                            ),
                            tileColor: Colors.transparent,
                            dense: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 30.0),
                  child: MaterialButton(
                    height: 45.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 16.0, 0.0),
                    color: const Color(0xFF7426EF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () async {
                      purchaseOutput = await revenue_cat.purchasePackage(
                        revenue_cat.offerings!.current!.lifetime!.identifier,
                      );
                      if (purchaseOutput!) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'You have successfully subscribe to the monthly plan!',
                              style: TextStyle(
                                color: Color(0xFFA9AAAC),
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor: Color(0xFF000000),
                          ),
                        );

                        /// Route to navigate to your dashboard
                        /// Replace it with yours
                        /// The current one will not work for you

                        // context.pushNamed(SeriesTitleViewWidget.routeName);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Something went wrong during purchase!',
                              style: TextStyle(
                                color: Color(0xFFA9AAAC),
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor: Color(0xFF000000),
                          ),
                        );
                      }
                    },
                    child: const Text('Subscribe Now'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
