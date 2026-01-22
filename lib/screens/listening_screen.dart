import 'package:flutter/material.dart';
import '../config/theme.dart';

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({Key? key}) : super(key: key);

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  bool isPlaying = false;
  double currentPosition = 0.3; // 0.0 to 1.0
  double playbackSpeed = 1.0;

  final String transcript = '''
Welcome to today's listening exercise. In this session, we'll practice understanding natural English conversation. 

Pay attention to the pronunciation, intonation, and rhythm of the speakers. Try to identify the main ideas and supporting details.

Remember, it's okay if you don't understand everything on the first listen. You can replay the audio as many times as you need.
''';

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
    // In a real app, control audio playback here
  }

  void _changeSpeed() {
    setState(() {
      if (playbackSpeed == 1.0) {
        playbackSpeed = 1.5;
      } else if (playbackSpeed == 1.5) {
        playbackSpeed = 2.0;
      } else {
        playbackSpeed = 0.5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listening Practice'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Audio Wave Visualization
            Container(
              height: 200,
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryAction.withOpacity(0.1),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Waveform bars (simplified visualization)
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(20, (index) {
                        final height = 20.0 + (index % 5) * 10;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 4,
                          height: isPlaying ? height : 20,
                          decoration: BoxDecoration(
                            color: AppColors.highlights,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Progress slider
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.highlights,
                      inactiveTrackColor: AppColors.highlights.withOpacity(0.3),
                      thumbColor: AppColors.primaryAction,
                      overlayColor: AppColors.primaryAction.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: currentPosition,
                      onChanged: (value) {
                        setState(() {
                          currentPosition = value;
                        });
                      },
                    ),
                  ),
                  
                  // Time labels
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(currentPosition * 180).toInt()}s',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '3:00',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Replay 10s
                  IconButton(
                    icon: const Icon(Icons.replay_10),
                    iconSize: 32,
                    color: AppColors.secondary,
                    onPressed: () {},
                  ),
                  
                  // Speed control
                  GestureDetector(
                    onTap: _changeSpeed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${playbackSpeed}x',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  
                  // Forward 10s
                  IconButton(
                    icon: const Icon(Icons.forward_10),
                    iconSize: 32,
                    color: AppColors.secondary,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Transcript
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.article_outlined,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Transcript',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    transcript,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: _togglePlayPause,
        backgroundColor: AppColors.primaryAction,
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          size: 36,
          color: Colors.white,
        ),
      ),
    );
  }
}
