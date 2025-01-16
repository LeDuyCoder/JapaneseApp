class word{
  final String vocabulary, wayread, mean, topic;
  final int level;

  word(this.vocabulary, this.wayread, this.mean, this.topic, this.level);

  Map<String, dynamic> toMap(){
    return {
      "word": vocabulary,
      "wayread": wayread,
      "mean": mean,
      "topic": topic,
      "level": level
    };
  }

  word coverModule(Map<String, dynamic> data){
    return word(
      data["word"], data["wayread"], data["mean"], data["topic"], data["level"]
    );
  }
}