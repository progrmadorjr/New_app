import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_app/note.dart';
import 'package:flutter_app/parcelas.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/contrato.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _percentage = 0.0;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _animation = Tween<double>(
      // 1.0 = 100%
      begin: 0.0,
      end: 0.1,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {
          _percentage = _animation.value;
        });
      });
    _animationController.forward();
    _loadImage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      final imageFile = File(imagePath);
      if (await imageFile.exists()) {
        setState(() {
          _imageFile = imageFile;
        });
      }
    }
  }

  Future<void> _saveImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_image', imagePath);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      const fileName = 'profile_image.jpg';
      final savedImage = File('${appDir.path}/$fileName');
      await savedImage.writeAsBytes(await pickedFile.readAsBytes());

      setState(() {
        _imageFile = savedImage;
      });
      await _saveImage(savedImage.path);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF002A3A),
        title: const Center(
          child: Text(
            'ON INVESTIMENTOS',
            style: TextStyle(
              fontSize: 20.0,
              color: const Color(0xFF8E481F),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: const Color(0xFF8E481F),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Note()),
              );
            },
          ),
        ],
      ),

      //Menu latereal do perfil

      drawer: Drawer(
        //cor de fundo inferior
        backgroundColor: const Color.fromARGB(255, 160, 89, 47),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text(
                'João Gomes',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              accountEmail: const Text(
                "Joãogomes@gmail.com",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              //codigo do perfil
              currentAccountPicture: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Center(
                        child: Text(
                          'Escolha uma imagem',
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Center(
                            child: Text(
                              'Galeria',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF8E481F),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                _imageFile = File(pickedFile.path);
                              });
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF8E481F),
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    child: ClipOval(
                      child: _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.person,
                              size: 50,
                            ),
                    ),
                  ),
                ),
              ),

              //imagem de fundo
              decoration: const BoxDecoration(
                color: Color(0xFF002A3A),
                image: DecorationImage(
                  image: NetworkImage(
                    'add aqui',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.description_rounded,
                color: Color(0xFF002A3A),
              ),
              title: const Text(
                'Parcelas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002A3A),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PARCELAS()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.assignment_ind_rounded,
                color: Color(0xFF002A3A),
              ),
              title: const Text(
                'Contrato',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002A3A),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Contrato()),
                );
              },
            ),
            Container(
              height: 1,
              color: const Color(0xFF002A3A),
              child: const Divider(),
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Color(0xFF002A3A),
              ),
              title: const Text(
                'Sair',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002A3A),
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Deseja realmente sair?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8E481F),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF8E481F),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            'Sair',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF8E481F),
                            ),
                          ),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      //gradiente fundo
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF002A3A),
              Color(0xFF8E481F),
            ],
          ),
        ),

        //container  1
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 150,
            ),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Lottie.network(
                  'https://assets10.lottiefiles.com/packages/lf20_abslwm4u.json',
                  height: 200,
                  width: 350,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF002A3A).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 350,
                    height: 30,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: LinearProgressIndicator(
                            value: _percentage,
                            backgroundColor:
                                const Color.fromARGB(255, 5, 52, 70),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF002A3A)),
                            minHeight: 30,
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${(_percentage * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color(0xFF8E481F),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Progresso da obra ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002A3A),
                  ),
                ),
                const SizedBox(height: 35),
                Container(
                  //container inferior
                  width: MediaQuery.of(context).size.width * 10,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: const Card(
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      color: Color(0xFF002A3A),
                                      width: 3.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://www.cedrotech.com/wp-content/uploads/2023/03/robo-de-investimento-o-que-voce-precisa-para-criar-um.jpg'),
                                  ),
                                ),
                              ),
                              const Text(
                                'Total aplicado',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF002A3A),
                                ),
                              ),
                              const Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      'R\$ 200.000',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF002A3A),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

//card
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: const Card(
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      color: Color(0xFF002A3A),
                                      width: 3.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://www.cedrotech.com/wp-content/uploads/2023/03/robo-de-investimento-o-que-voce-precisa-para-criar-um.jpg'),
                                  ),
                                ),
                              ),
                              const Text(
                                'Total aplicado',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF002A3A),
                                ),
                              ),
                              const Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      'R\$ 20.000',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF002A3A),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      //card 3
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: const Card(
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      color: Color(0xFF002A3A),
                                      width: 3.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://www.cedrotech.com/wp-content/uploads/2023/03/robo-de-investimento-o-que-voce-precisa-para-criar-um.jpg'),
                                  ),
                                ),
                              ),
                              const Text(
                                'Rentabilidade',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF002A3A)),
                              ),
                              const Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      '45%',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF002A3A),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
