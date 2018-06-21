var statePrior = function() {
  return categorical({ps: [0.5,0.5], vs: [["zebra"], ["okapi"]]});
};

var utterances = ["iszebra", "lookslikezebra"];

var cost = {
  "iszebra": 5,
  "lookslikezebra": 5,
};

var utterancePrior = function() {
  var uttProbs = map(function(u) {return Math.exp(-cost[u]) }, utterances);
  //return categorical({ps: [0.5,0.5], vs: ["iszebra", "lookslikezebra"]});
  return categorical(uttProbs, utterances);
};

var literalMeanings = {
  lookslikezebra: function(state) { return state.includes("zebra") || state.includes("okapi"); },
  iszebra: function(state) { return state.includes("zebra"); },
};

var literalListener = cache(function(utt) {
  return Infer({model: function(){
    var state = statePrior()
    var meaning = literalMeanings[utt]
    condition(meaning(state))
    return state
  }})
});

// set speaker optimality
var alpha = 2

// pragmatic speaker
var speaker = cache(function(state) {
  return Infer({model: function(){
    var utt = utterancePrior()
    factor(alpha * literalListener(utt).score(state))
    return utt
  }})
});

// pragmatic listener
var pragmaticListener = cache(function(utt) {
  return Infer({model: function(){
    var state = statePrior()
    observe(speaker(state),utt)
    return state
  }})
});

//question 3 & 4
viz.table(pragmaticListener("lookslikezebra"));