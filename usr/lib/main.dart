import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matematika Kelas 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        fontFamily: 'Comic Sans MS', // Fallback to a playful font if available, or default
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/quiz': (context) => const QuizScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            const Text(
              'Matematika\nKelas 2 SD',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ayo Belajar Berhitung!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/quiz');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: const Text(
                'MULAI',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionCount = 0;
  int _score = 0;
  int _totalQuestions = 10;
  
  late int _num1;
  late int _num2;
  late String _operator;
  late int _correctAnswer;
  late List<int> _options;
  
  bool _answered = false;
  int? _selectedAnswer;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final random = Random();
    // Kelas 2 SD: Penjumlahan dan Pengurangan sampai 100
    _operator = random.nextBool() ? '+' : '-';
    
    if (_operator == '+') {
      _num1 = random.nextInt(50) + 1; // 1-50
      _num2 = random.nextInt(40) + 1; // 1-40
      _correctAnswer = _num1 + _num2;
    } else {
      _num1 = random.nextInt(50) + 20; // 20-70 (ensure result is positive)
      _num2 = random.nextInt(_num1); // Ensure result is positive
      _correctAnswer = _num1 - _num2;
    }

    _generateOptions();
    setState(() {
      _answered = false;
      _selectedAnswer = null;
    });
  }

  void _generateOptions() {
    final random = Random();
    Set<int> optionsSet = {_correctAnswer};
    
    while (optionsSet.length < 4) {
      int offset = random.nextInt(10) + 1;
      bool add = random.nextBool();
      int wrongOption = add ? _correctAnswer + offset : _correctAnswer - offset;
      if (wrongOption >= 0) {
        optionsSet.add(wrongOption);
      }
    }
    
    _options = optionsSet.toList()..shuffle();
  }

  void _checkAnswer(int answer) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      _isCorrect = answer == _correctAnswer;
      if (_isCorrect) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_questionCount < _totalQuestions - 1) {
      setState(() {
        _questionCount++;
      });
      _generateQuestion();
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Selesai!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _score > 7 ? Icons.star : Icons.star_border,
              size: 60,
              color: Colors.orange,
            ),
            const SizedBox(height: 10),
            Text(
              'Nilai Kamu: ${_score * 10}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Benar $_score dari $_totalQuestions soal'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to home
            },
            child: const Text('Ke Menu Utama'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _score = 0;
                _questionCount = 0;
                _generateQuestion();
              });
            },
            child: const Text('Main Lagi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soal ${_questionCount + 1}/$_totalQuestions'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Skor: ${_score * 10}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Question Card
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_num1 $_operator $_num2 = ?',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Options Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.5,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final option = _options[index];
                  Color btnColor = Colors.lightBlue.shade100;
                  Color textColor = Colors.blue.shade900;

                  if (_answered) {
                    if (option == _correctAnswer) {
                      btnColor = Colors.green.shade300;
                      textColor = Colors.white;
                    } else if (option == _selectedAnswer) {
                      btnColor = Colors.red.shade300;
                      textColor = Colors.white;
                    }
                  }

                  return ElevatedButton(
                    onPressed: _answered ? null : () => _checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      foregroundColor: textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      '$option',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_answered)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton.icon(
                  onPressed: _nextQuestion,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(_questionCount < _totalQuestions - 1 ? 'Soal Selanjutnya' : 'Lihat Hasil'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
