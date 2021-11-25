class TimelineItem {
  final Duration timeRemaining;
  final Duration timeUntilStart;
  final String phaseName;
  final String ingredientName;
  get timeTillNextAlert {
    return timeUntilStart <= Duration.zero ? timeRemaining : timeUntilStart;
  }

  TimelineItem(this.timeRemaining,this.timeUntilStart, this.phaseName, this.ingredientName);


}