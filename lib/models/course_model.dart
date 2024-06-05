class Course {
  String id;
  String title;
  String description;
  String imageUrl;
  List<Lesson> lessons;
  double price;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.lessons,
    required this.price,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      lessons: (json['lessons'] as List)
          .map((lesson) => Lesson.fromJson(lesson))
          .toList(),
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
      'price': price,
    };
  }
}

class Lesson {
  String id;
  String courseId;
  String title;
  String description;
  String videoUrl;
  List<Quiz> quizes;

  Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.quizes,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      courseId: json['courseId'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      quizes:
          (json['quizes'] as List).map((quiz) => Quiz.fromJson(quiz)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'quizes': quizes.map((quiz) => quiz.toJson()).toList(),
    };
  }
}

class Quiz {
  String id;
  String question;
  List<String> options;
  int correctOptionIndex;

  Quiz({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }
}
