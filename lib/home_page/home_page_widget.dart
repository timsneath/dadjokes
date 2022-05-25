import '../backend/api_requests/api_calls.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  ApiCallResponse theJoke;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          theJoke = await DadjokeCall.call();

          setState(() {});
        },
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        icon: Icon(
          Icons.mood,
          color: FlutterFlowTheme.of(context).secondaryText,
        ),
        elevation: 8,
        label: Text(
          'New Joke',
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-0.05, 0),
                child: Image.asset(
                  'assets/images/title-image.png',
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: AlignmentDirectional(0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0, -0.05),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                              child: FutureBuilder<ApiCallResponse>(
                                future: DadjokeCall.call(),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryColor,
                                        ),
                                      ),
                                    );
                                  }
                                  final textDadjokeResponse = snapshot.data;
                                  return AutoSizeText(
                                    getJsonField(
                                      (theJoke?.jsonBody ?? ''),
                                      r'''$.joke''',
                                    ).toString(),
                                    textAlign: TextAlign.start,
                                    style:
                                        FlutterFlowTheme.of(context).bodyText1,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(1, 0),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30,
                            borderWidth: 1,
                            buttonSize: 60,
                            icon: Icon(
                              Icons.ios_share,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 30,
                            ),
                            onPressed: () async {
                              await Share.share(getJsonField(
                                (theJoke?.jsonBody ?? ''),
                                r'''$.joke''',
                              ).toString());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 60,
                    icon: Icon(
                      Icons.info_outlined,
                      color: FlutterFlowTheme.of(context).primaryBtnText,
                      size: 30,
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (alertDialogContext) {
                          return AlertDialog(
                            title: Text('About Dad Jokes'),
                            content: Text(
                                'Dad jokes is brought to you by Tim Sneath (@timsneath),  proud dad of Naomi, Esther, and Silas. May your children groan like mine do.\n\nDad jokes come from https://icanhazdadjoke.com, with thanks.'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(alertDialogContext),
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
