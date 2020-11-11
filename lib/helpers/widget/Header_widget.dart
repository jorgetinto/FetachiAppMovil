import 'package:flutter/material.dart';

class HeaderWave extends StatelessWidget {

  final Color color;

  const HeaderWave({this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: _HeaderWavePainter(color: this.color),
      ),
    );
  }
}

class _HeaderWavePainter extends CustomPainter{

  final Color color;

  _HeaderWavePainter( {@required this.color});

  @override
  void paint(Canvas canvas, Size size) {

      final lapiz = new Paint();

      // propiedades
      lapiz.color = this.color; //Color(0xff615AAB);
      lapiz.style = PaintingStyle.fill;
      lapiz.strokeWidth = 20;

      final path = new Path();

      // dibujar con el path y lapiz
      path.lineTo(0, size.height * 0.25);
      path.quadraticBezierTo(size.width * 0.25, size.height * 0.3, size.width * 0.5, size.height * 0.25);
      path.quadraticBezierTo(size.width * 0.75, size.height * 0.2, size.width, size.height * 0.25);
      path.lineTo(size.width, 0);
      
      canvas.drawPath(path, lapiz);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
      return true;
  }

}

class HeaderWaveGradient extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
       painter: _HeaderWaveGradientPainter(),
      ),
    );
  }
}

class _HeaderWaveGradientPainter extends CustomPainter{
  

  @override
  void paint(Canvas canvas, Size size) {

    final Rect rect = new Rect.fromCircle(
      center: Offset(0.0, 60.0),
      radius: 180
    );

      final Gradient gradiente = new LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        
        colors: <Color>[
                        Color(0xfff0000cc),
                        Color(0xff0a0a96)
        ],
        stops: [0.2,1.0]
      );

      final lapiz = new Paint()..shader = gradiente.createShader(rect);

      // propiedades
      lapiz.style = PaintingStyle.fill;
      lapiz.strokeWidth = 20;

      final path = new Path();

      // dibujar con el path y lapiz
      // path.lineTo(0, size.height * 0.35);
      // path.quadraticBezierTo(size.width * 0.35, size.height * 0.4, size.width * 0.6, size.height * 0.35);
      // path.quadraticBezierTo(size.width * 0.8, size.height * 0.3, size.width, size.height * 0.35);
      // path.lineTo(size.width, 0);
      path.lineTo(0, size.height * 0.25);
      path.quadraticBezierTo(size.width * 0.25, size.height * 0.3, size.width * 0.5, size.height * 0.25);
      path.quadraticBezierTo(size.width * 0.75, size.height * 0.2, size.width, size.height * 0.25);
      path.lineTo(size.width, 0);
      
      canvas.drawPath(path, lapiz);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
      return true;
  }

}