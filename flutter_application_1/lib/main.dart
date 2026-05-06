import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: JuegoCacho()));
}

class JuegoCacho extends StatefulWidget {
  @override
  _JuegoCachoState createState() => _JuegoCachoState();
}

class _JuegoCachoState extends State<JuegoCacho> {
  List<int> dados = [1, 1, 1, 1, 1];
  String resultadoJugada = "🎲 Lanza los dados";
  int lanzamientos = 3;
  List<bool> dadosGuardados = [false, false, false, false, false];

  void lanzarCacho() {
    if (lanzamientos > 0) {
      setState(() {
        for (int i = 0; i < 5; i++) {
          if (!dadosGuardados[i]) {
            dados[i] = Random().nextInt(6) + 1;
          }
        }
        lanzamientos--;
        resultadoJugada = evaluarJugada(dados);

        if (lanzamientos == 0) {
          resultadoJugada += " ⚠️ Sin más lanzamientos";
        }
      });
    }
  }

  void reiniciarLanzamientos() {
    setState(() {
      lanzamientos = 3;
      dadosGuardados = [false, false, false, false, false];
      dados = [1, 1, 1, 1, 1];
      resultadoJugada = "🎲 Lanza los dados";
    });
  }

  void toggleGuardarDado(int index) {
    if (lanzamientos > 0 && lanzamientos < 3) {
      setState(() {
        dadosGuardados[index] = !dadosGuardados[index];
      });
    }
  }

  String evaluarJugada(List<int> dados) {
    // Conteo de frecuencias de cada número
    Map<int, int> conteo = {};
    for (var dado in dados) {
      conteo[dado] = (conteo[dado] ?? 0) + 1;
    }

    // Ordenar dados para verificar escaleras
    List<int> ordenados = List.from(dados)..sort();

    // Obtener frecuencias ordenadas de mayor a menor
    var frecuencias = conteo.values.toList()..sort((a, b) => b.compareTo(a));

    // 🏆 GRANDE/DORMIDA (5 dados iguales)
    if (frecuencias[0] == 5) {
      return "🏆 GRANDE/DORMIDA 🏆";
    }

    // 🃏 PÓKER (4 dados iguales)
    if (frecuencias[0] == 4) {
      return "🃏 PÓKER";
    }

    // 🏠 FULL (3 de un valor y 2 de otro)
    if (frecuencias[0] == 3 && frecuencias[1] == 2) {
      return "🏠 FULL";
    }

    // 🔺 TRICA (3 dados iguales y 2 distintos)
    if (frecuencias[0] == 3 && frecuencias[1] == 1) {
      return "🔺 TRICA";
    }

    // 👥 DOBLE PAR (2 pares distintos y 1 dado distinto)
    if (frecuencias.length == 3 && frecuencias[0] == 2 && frecuencias[1] == 2) {
      return "👥 DOBLE PAR";
    }

    // 🔥 ESCALERAS
    // Escalera menor: 1-2-3-4-5
    if (ordenados.toString() == [1, 2, 3, 4, 5].toString()) {
      return "📏 ESCALERA MENOR";
    }

    // Escalera media: 2-3-4-5-6
    if (ordenados.toString() == [2, 3, 4, 5, 6].toString()) {
      return "📐 ESCALERA MEDIA";
    }

    // Escalera mayor: 3-4-5-6-1 (en círculo)
    if (ordenados.toString() == [1, 3, 4, 5, 6].toString()) {
      return "📏 ESCALERA MAYOR";
    }

    // ❌ NULO (casos especiales sin valor)
    // 1-2-3-5-6
    if (ordenados.toString() == [1, 2, 3, 5, 6].toString()) {
      return "❌ NULO";
    }
    // 1-2-4-5-6
    if (ordenados.toString() == [1, 2, 4, 5, 6].toString()) {
      return "❌ NULO";
    }
    // 1-2-3-4-6
    if (ordenados.toString() == [1, 2, 3, 4, 6].toString()) {
      return "❌ NULO";
    }

    // 👥 PAR (2 dados iguales y 3 distintos)
    if (frecuencias[0] == 2) {
      // Verificar cada tipo de par específico
      if (conteo[1] == 2 && conteo.length == 4) {
        return "🎯 BALAS (Par de 1)";
      }
      if (conteo[2] == 2 && conteo.length == 4) {
        return "🎯 TONTOS (Par de 2)";
      }
      if (conteo[3] == 2 && conteo.length == 4) {
        return "🎯 TRENES (Par de 3)";
      }
      if (conteo[4] == 2 && conteo.length == 4) {
        return "🎯 CUADRAS (Par de 4)";
      }
      if (conteo[5] == 2 && conteo.length == 4) {
        return "🎯 QUINAS (Par de 5)";
      }
      if (conteo[6] == 2 && conteo.length == 4) {
        return "🎯 SENAS (Par de 6)";
      }
      return "🎲 PAR";
    }

    // Si no cumple ninguna condición, es BALA (dado suelto)
    return "💥 BALA";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade900, Colors.green.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 🎲 TÍTULO
              Text(
                "🎲 CACHO BOLIVIANO",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              // 📊 CONTADOR DE LANZAMIENTOS
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "🎲 Lanzamientos restantes: $lanzamientos/3",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 📢 RESULTADO
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white54),
                ),
                child: Text(
                  resultadoJugada,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // 🎲 DADOS (con opción de guardar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () => toggleGuardarDado(index),
                    child: Stack(
                      children: [
                        _dado(dados[index]),
                        if (dadosGuardados[index])
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.yellow,
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // 💡 INSTRUCCIÓN
              if (lanzamientos > 0 && lanzamientos < 3)
                Text(
                  "💡 Toca un dado para guardarlo/liberarlo",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),

              // 🔘 BOTONES
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (lanzamientos == 0)
                    ElevatedButton(
                      onPressed: reiniciarLanzamientos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                      ),
                      child: Text(
                        "🔄 NUEVA JUGADA",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  SizedBox(width: 20),

                  ElevatedButton(
                    onPressed: lanzamientos > 0 ? lanzarCacho : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lanzamientos > 0
                          ? Colors.amber
                          : Colors.grey,
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                    ),
                    child: Text(
                      lanzamientos > 0
                          ? "🎲 LANZAR DADOS ($lanzamientos/3)"
                          : "🎲 SIN LANZAMIENTOS",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // 📋 LEYENDA DE JUGADAS
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      "📋 JUGADAS ESPECIALES",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 5),
                    Wrap(
                      spacing: 10,
                      children: [
                        _chipLeyenda("🏆 DORMIDA", Colors.red),
                        _chipLeyenda("🃏 PÓKER", Colors.purple),
                        _chipLeyenda("🏠 FULL", Colors.orange),
                        _chipLeyenda("🔺 TRICA", Colors.blue),
                        _chipLeyenda("👥 DOBLE PAR", Colors.teal),
                        _chipLeyenda("📏 ESCALERAS", Colors.green),
                        _chipLeyenda("🎯 PAR ESPECIAL", Colors.amber),
                        _chipLeyenda("💥 BALA", Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chipLeyenda(String texto, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color),
      ),
      child: Text(texto, style: TextStyle(color: Colors.white, fontSize: 10)),
    );
  }

  // 🎲 DADO CON PUNTOS
  Widget _dado(int numero) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(3, 4)),
        ],
      ),
      child: Stack(children: _buildPuntos(numero)),
    );
  }

  // 🔧 PUNTOS DEL DADO
  List<Widget> _buildPuntos(int numero) {
    List<Widget> puntos = [];

    Widget punto(double x, double y) {
      return Positioned(
        left: x,
        top: y,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    switch (numero) {
      case 1:
        puntos.add(punto(32, 32));
        break;
      case 2:
        puntos.addAll([punto(8, 8), punto(56, 56)]);
        break;
      case 3:
        puntos.addAll([punto(8, 8), punto(32, 32), punto(56, 56)]);
        break;
      case 4:
        puntos.addAll([punto(8, 8), punto(56, 8), punto(8, 56), punto(56, 56)]);
        break;
      case 5:
        puntos.addAll([
          punto(8, 8),
          punto(56, 8),
          punto(32, 32),
          punto(8, 56),
          punto(56, 56),
        ]);
        break;
      case 6:
        puntos.addAll([
          punto(8, 8),
          punto(8, 32),
          punto(8, 56),
          punto(56, 8),
          punto(56, 32),
          punto(56, 56),
        ]);
        break;
    }

    return puntos;
  }
}
