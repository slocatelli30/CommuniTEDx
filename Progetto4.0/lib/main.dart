import 'package:flutter/material.dart';
import 'talk_repository.dart';
import 'models/talk.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTEDx',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    this.title = 'MyTEDx'
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // controller per getTalksByTag
  final TextEditingController _controller = TextEditingController();
  // controller1 e controller2 per getTalksBy2Tags
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  // controller3 per getTalkByUrl
  final TextEditingController _controller3 = TextEditingController();
  // lista contenenti i talks da ritornare all'utente
  late Future<List<Talk>> _talks;
  // inizializzata prima pagina
  int page = 1;
  bool init = true;
  // per capire che scelta sto facendo
  int sceltaopzione = 0;

  @override
  void initState() {
    super.initState();
    _talks = initEmptyList();
    init = true;
  }

  // metodo getTalksByTag
  void _getTalksByTag() async {
    setState(() {
      init = false;
      // set scelta
      sceltaopzione = 1;
      _talks = getTalksByTag(_controller.text.trimRight(), page);
    });
  }

  // metodo getTalksBy2Tags
  void _getTalksBy2Tags() async {
    setState(() {
      init = false;
      // set scelta
      sceltaopzione = 2;
      _talks = getTalksBy2Tags(_controller1.text.trimRight(), _controller2.text.trimRight(), page);
    });
  }

  // metodo getTalkByUrl
  void _getTalkByUrl() async {
    setState(() {
      init = false;
      // set scelta
      sceltaopzione = 3;
      _talks = getTalksByUrl(_controller3.text.trimRight(), page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My TedX App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My TEDx App'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (init)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _controller,
                      decoration:
                          const InputDecoration(hintText: 'Enter your favorite talk'),
                    ),
                    ElevatedButton(
                      child: const Text('Search by tag'),
                      onPressed: () {
                        page = 1;
                        _getTalksByTag();
                      },
                    ),

                    // TextField per il primo tag (getTalksBy2Tags)
                    TextField(
                      controller: _controller1,
                      decoration:
                          const InputDecoration(hintText: 'Enter your favorite first talk'),
                    ),

                    // TextField per il secondo tag (getTalksBy2Tags)
                    TextField(
                      controller: _controller2,
                      decoration:
                          const InputDecoration(hintText: 'Enter your favorite second talk'),
                    ),

                    // ElevateButton per due tags (and logica)
                    ElevatedButton(
                      child: const Text('Search by 2 tags'),
                      onPressed: () {
                        page = 1;
                        _getTalksBy2Tags();
                      },
                    ),

                    // TextField per url (getTalkByUrl)
                    TextField(
                      controller: _controller3,
                      decoration:
                          const InputDecoration(hintText: 'Enter your favorite url talk'),
                    ),

                    // ElevateButton per url (getTalkByUrl)
                    ElevatedButton(
                      child: const Text('Search by url'),
                      onPressed: () {
                        page = 1;
                        _getTalkByUrl();
                      },
                    ),

                  ],
                )
              : FutureBuilder<List<Talk>>(
                  future: _talks,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Scaffold(
                          appBar: AppBar(
                            title: Text(
                              // if inline per il testo dell'AppBar
                              sceltaopzione == 1 ? "#${_controller.text}" : 
                              ( (sceltaopzione == 2) ? ("#${_controller1.text}, #${_controller2.text}") : 
                              ("Info about the url searched") ) ,
                            ),
                          ),
                          body: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: ListTile(
                                    subtitle:
                                        Text(
                                          // if inline per related video o mainSpeaker
                                          sceltaopzione == 3 ? (snapshot.data![index].watchNext.toString()) : 
                                          snapshot.data![index].mainSpeaker
                                        ),
                                    title: Text(snapshot.data![index].title)),
                                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(snapshot.data![index].details))),
                              );
                            },
                          ),
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.centerDocked,
                          floatingActionButton: FloatingActionButton(
                            child: Icon(
                              //Icons.arrow_drop_down
                              sceltaopzione == 3 ? Icons.check : Icons.arrow_drop_down,
                            ),
                            onPressed: () {
                              // if per il caricamento della pagina successiva
                              if (snapshot.data!.length >= 6 && sceltaopzione==1) {
                                page = page + 1;
                                _getTalksByTag();
                              }
                              else if(snapshot.data!.length >= 6 && sceltaopzione==2)
                              {
                                page = page + 1;
                                _getTalksBy2Tags();
                              }
                            },
                          ),
                          bottomNavigationBar: BottomAppBar(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.home),
                                  onPressed: () {
                                    setState(() {
                                      init = true;
                                      page = 1;
                                      // pulizia dei TextField
                                      _controller.text = "";
                                      _controller1.text = "";
                                      _controller2.text = "";
                                      _controller3.text = "";
                                    });
                                  },
                                )
                              ],
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return const CircularProgressIndicator();
                  },
                ),
        ),
      ),
    );
  }
}