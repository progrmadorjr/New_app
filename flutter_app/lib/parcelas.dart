import 'package:flutter/material.dart';

class PARCELAS extends StatefulWidget {
  const PARCELAS({Key? key}) : super(key: key);

  @override
  State<PARCELAS> createState() => _PARCELASState();
}

class _PARCELASState extends State<PARCELAS> {
  int _selectedRow = -1;
  bool _isPaid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002A3A),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFF002A3A),
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  final rowNumber = index + 1;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRow = index;
                        _isPaid = !_isPaid;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF8E481F)),
                        color: _selectedRow == index
                            ? Color.fromARGB(147, 241, 244, 245)
                            : Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$rowNumber Parcela',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: const Color(0xFF8E481F),
                                  ),
                                ),
                                if (_selectedRow == index && _isPaid)
                                  // adiciona um subtitulo se a parcela foi paga
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      'Pago',
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          color:
                                              Color.fromARGB(255, 54, 148, 57)),
                                    ),
                                  ),
                              ],
                            ),
                            const Text(
                              'R\$ 500',
                              style: TextStyle(
                                fontSize: 20,
                                color: const Color(0xFF8E481F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
