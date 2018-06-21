  var filler_block1 = [
    {type: "filler", id: "low_right", fuckeditup: false, sentence: "A handful of people showed up to the meeting.", suggests: "Nobody showed up to the meeting"},
    // {type: "filler", sentence: "Every basketball player except Lidia is over 6 feet tall.", suggests: "Lidia is a basketball player"},
    // {type: "filler", sentence: "Maria gave birth to twins last week.", suggests: "Maria gave birth to two children last week"},
    {type: "filler", id: "high_right", fuckeditup: false, sentence: "Judith's hometown has a population of less than 10,000.", suggests: "Fewer than 10,000 people live in Judith's hometown"},];

  // var filler_block2 = [
  //   {type: "filler", sentence: "Every professor except Professor Smith gave Ruchi an A this semester.", suggests: "Professor Smith gave Ruchi a grade lower than A this semester"},
  //   {type: "filler", sentence: "It finally rained in Watsonville on Thursday.", suggests: "Before Thursday, it had not rained in Watsonville in a long time"},
  //   {type: "filler", sentence: "Bill wants to study abroad in France next semester.", suggests: "Bill wants to study abroad in Paris next semester"},
  //   {type: "filler", sentence: "It must be raining outside right now.", suggests: "It's possible that it isn't raining outside right now"},];

  var condit_dict = { 
      // EXCLUSIVITY INFERENCE TRIALS: PRIME OF FORM AND MEANING
      orprime_either : [
      {type: "prime", id: "party", sentence: "Joanne invited David or Samantha to the party.", suggests: "Joanne invited only one of these two people to the party"},
      {type: "prime", id: "birthday", sentence: "Bill gave Mary flowers or chocolate for her birthday.", suggests: "Bill gave only one of these things to Mary for her birthday"},
      {type: "prime", id: "mail", sentence: "Jenny received a bill or an invitation in the mail today.", suggests: "Jenny received only one of these things in the mail today"},
      {type: "prime", id: "dealership", sentence: "Jack purchased a sports car or a truck at the dealership.", suggests: "Jack purchased only one of these things at the dealership"},
      {type: "crit", id: "inherit", sentence: "Peter inherited either the painting or the wardrobe from his grandmother.", suggests: "Peter inherited only one of these things from his grandmother"},
      ], 
      orprime_notboth : [
      {type: "prime", id: "party", sentence: "Joanne invited David or Samantha to the party.", suggests: "Joanne invited only one of these two people to the party"},
      {type: "prime", id: "birthday", sentence: "Bill gave Mary flowers or chocolate for her birthday.", suggests: "Bill gave only one of these things to Mary for her birthday"},
      {type: "prime", id: "mail", sentence: "Jenny received a bill or an invitation in the mail today.", suggests: "Jenny received only one of these things in the mail today"},
      {type: "prime", id: "dealership", sentence: "Jack purchased a sports car or a truck at the dealership.", suggests: "Jack purchased only one of these things at the dealership"},
      {type: "crit", id: "inherit", sentence: "Peter inherited the painting or the wardrobe from his grandmother, but not both.", suggests: "Peter inherited only one of these things from his grandmother"},
      ], 
      orprime_and : [
      {type: "prime", id: "party", sentence: "Joanne invited David or Samantha to the party.", suggests: "Joanne invited only one of these two people to the party"},
      {type: "prime", id: "birthday", sentence: "Bill gave Mary flowers or chocolate for her birthday.", suggests: "Bill gave only one of these things to Mary for her birthday"},
      {type: "prime", id: "mail", sentence: "Jenny received a bill or an invitation in the mail today.", suggests: "Jenny received only one of these things in the mail today"},
      {type: "prime", id: "dealership", sentence: "Jack purchased a sports car or a truck at the dealership.", suggests: "Jack purchased only one of these things at the dealership"},
      {type: "crit", id: "inherit", sentence: "Peter inherited the painting and the wardrobe from his grandmother.", suggests: "Peter inherited only one of these things from his grandmother"},
      ], 
      // // ORTHOGONAL INFERENCE TRIALS: NO FORM PRIME, NO MEANING PRIME
      // or_eitherorprime_orthog : [
      // {type: "prime", id: "inherit", sentence: "Peter inherited either the painting or the wardrobe from his grandmother.", suggests: "Peter's grandmother has passed away"},
      // {type: "prime", id: "birthday", sentence: "Bill gave Mary either flowers or chocolate for her birthday.", suggests: "Mary received a gift from Bill"},
      // {type: "prime", id: "mail", sentence: "Jenny received either a bill or an invitation in the mail today.", suggests: "The postal service delivered Jenny's mail today"},
      // {type: "prime", id: "dealership", sentence: "Jack purchased either a sports car or a truck at the dealership.", suggests: "Jack made a purchase at the dealership"},
      // {type: "crit", id: "party", sentence: "Joanne invited David or Samantha to the party.", suggests: "Joanne invited only one of these two people to the party"},
      // ], 
      // or_notbothprime_orthog : [
      // {type: "prime", id: "inherit", sentence: "Peter inherited the painting or the wardrobe from his grandmother, but not both.", suggests: "Peter's grandmother has passed away"},
      // {type: "prime", id: "birthday", sentence: "Bill gave Mary flowers or chocolate for her birthday, but not both.", suggests: "Mary received a gift from Bill"},
      // {type: "prime", id: "mail", sentence: "Jenny received a bill or an invitation in the mail today, but not both.", suggests: "The postal service delivered Jenny's mail today"},
      // {type: "prime", id: "dealership", sentence: "Jack purchased a sports car or a truck at the dealership, but not both.", suggests: "Jack made a purchase at the dealership"},
      // {type: "crit", id: "party", sentence: "Joanne invited David or Samantha to the party.", suggests: "Joanne invited only one of these two people to the party"},
      // ],
      // or_andprime_orthog : [
      // {type: "prime", id: "inherit", sentence: "Peter inherited the painting and the wardrobe from his grandmother.", suggests: "Peter's grandmother has passed away"},
      // {type: "prime", id: "birthday", sentence: "Bill gave Mary flowers and chocolate for her birthday.", suggests: "Mary received a gift from Bill"},
      // {type: "prime", id: "mail", sentence: "Jenny received a bill and an invitation in the mail today.", suggests: "The postal service delivered Jenny's mail today"},
      // {type: "prime", id: "dealership", sentence: "Jack purchased a sports car and a truck at the dealership.", suggests: "Jack made a purchase at the dealership"},
      // {type: "crit", id: "party", sentence: "Joanne invited David or Samantha to the party.", suggests: "Joanne invited only one of these two people to the party"},
      // ],  
      // or_noprime_orthog : [
      // {type: "prime", id: "inherit", sentence: "Peter inherited the painting from his grandmother, whereas his aunt Jill inherited the wardrobe.", suggests: "Peter's grandmother has passed away"},
      // {type: "prime", id: "birthday", sentence: "Bill gave Mary flowers for her birthday, whereas John gave her chocolate.", suggests: "Mary received a gift from Bill"},
      // {type: "prime", id: "mail", sentence: "Jenny received a bill in the mail today, whereas she had received invitation in the mail yesterday.", suggests: "The postal service delivered Jenny's mail today"},
      // {type: "prime", id: "dealership", sentence: "Jack purchased a sports car at the dealership, whereas Harvey purchased a truck.", suggests: "Jack made a purchase at the dealership"},
      // {type: "crit", id: "party", sentence: "Joanne invited David or Samantha to the party.", suggests: "Joanne invited only one of these two people to the party"},
      // ],
      // // ONLY THE FIRST CONJUNCT
      // or_noprime_orthog_firstconj : [
      // {type: "prime", id: "inherit", sentence: "Peter inherited the painting from his grandmother.", suggests: "Peter's grandmother has passed away"},
      // {type: "prime", id: "birthday", sentence: "Bill gave Mary flowers for her birthday.", suggests: "Mary received a gift from Bill"},
      // {type: "prime", id: "mail", sentence: "Jenny received a bill in the mail today.", suggests: "The postal service delivered Jenny's mail today"},
      // {type: "prime", id: "dealership", sentence: "Jack purchased a sports car at the dealership.", suggests: "Jack made a purchase at the dealership"},
      // {type: "crit", id: "party", sentence: "Joanne invited David or Samantha to the party.", suggests: "Joanne invited only one of these two people to the party"},
      // ],
      // ONLY THE CRITICAL TRIAL
      // or_noprime_oneshot : [
      // {type: "crit", id: "party", sentence: "Joanne invited David or Samantha to the party.", suggests: "Joanne invited only one of these two people to the party"},
      // ],
     };

var order = 1;

function make_slides(f) {
  var   slides = {};
  // var present_list = filler_block1.concat(condit_dict[exp.condition][0], filler_block2, condit_dict[exp.condition][1]);

  // if (exp.order == "4fillerspacing") {
  //   var present_list = filler_block1.concat(condit_dict[exp.condition][0], filler_block2, condit_dict[exp.condition][1]);
  // } else if (exp.order == "nofillerspacing") {
  //   var present_list = filler_block1.concat(condit_dict[exp.condition][0], condit_dict[exp.condition][1], filler_block2);
  // } else {
  //   console.log("Order is undefined");
  // }

  if (exp.condition == "or_noprime_oneshot") {
    var present_list = condit_dict[exp.condition];
  } else {
    var priming = _.shuffle(condit_dict[exp.condition].slice(0,4));
    var present_list = priming.concat(condit_dict[exp.condition][4]);
  }

  slides.consent = slide({
     name : "consent",
     start: function() {
      exp.startT = Date.now();
      $("#consent_2").hide();
      exp.consent_position = 0;
     },
    button : function() {
      if(exp.consent_position == 0) {
         exp.consent_position++;
         $("#consent_1").hide();
         $("#consent_2").show();
      } else {
        exp.go(); //use exp.go() if and only if there is no "present" data.
      }
    }
  });

  slides.i0 = slide({
     name : "i0",
     start: function() {
      exp.startT = Date.now();
     }
  });

  slides.instructions = slide({
    name : "instructions",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.getready = slide({
    name : "getready",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.getready_practice = slide({
    name : "getready_practice",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

   slides.practice_trials = slide({
    name : "one_slider",

    /* trial information for this block
     (the variable 'stim' will change between each of these values,
      and for each of these, present_handle will be run.) */

    present : filler_block1,

    //this gets run only at the beginning of the block
    present_handle : function(stim) {
      $(".err").hide();
      $(".err_practice").hide();

      this.stim = stim; //I like to store this information in the slide so I can record it later.

      $(".prompt").html('<b>"' + stim.sentence + '"</b>' + "<p> How likely is it that the speaker meant to suggest: <p> <i> " + stim.suggests + ".</i>");
      this.init_sliders();
      exp.sliderPost = null; //erase current slider value
    },

    button : function() {
      if (exp.sliderPost == null) {
        $(".err").show();
      } else if (exp.sliderPost < 0.50 && this.stim.id == "high_right") {
        $(".err").hide();
        $(".err_practice").show();
        this.stim.fuckeditup = true;
      } else if (exp.sliderPost > 0.50 && this.stim.id == "low_right") {
        $(".err").hide();
        $(".err_practice").show();
        this.stim.fuckeditup = true;
      } 
      else {
        this.log_responses();

        /* use _stream.apply(this); if and only if there is
        "present" data. (and only *after* responses are logged) */
        _stream.apply(this);
      }
    },

    init_sliders : function() {
      utils.make_slider("#single_slider", function(event, ui) {
        exp.sliderPost = ui.value;
      });
    },

    log_responses : function() {
      exp.data_trials.push({
        "trial_type" : "practice_trial",
        "response" : exp.sliderPost,
        "type" : this.stim.type,
        "id" : this.stim.id,
        "error" : this.stim.fuckeditup,
        "order" : order,
      });
    order = order + 1;
    }
  });

  slides.one_slider = slide({
    name : "one_slider",

    /* trial information for this block
     (the variable 'stim' will change between each of these values,
      and for each of these, present_handle will be run.) */

    present : present_list,

    //this gets run only at the beginning of the block
    present_handle : function(stim) {
      $(".err").hide();
      $(".err_practice").hide();

      this.stim = stim; //I like to store this information in the slide so I can record it later.

      $(".prompt").html('<b>"' + stim.sentence + '"</b>' + "<p> How likely is it that the speaker meant to suggest: <p> <i> " + stim.suggests + ".</i>");
      this.init_sliders();
      exp.sliderPost = null; //erase current slider value
    },

    button : function() {
      if (exp.sliderPost == null) {
        $(".err").show();
      } else {
        this.log_responses();

        /* use _stream.apply(this); if and only if there is
        "present" data. (and only *after* responses are logged) */
        _stream.apply(this);
      }
    },

    init_sliders : function() {
      utils.make_slider("#single_slider", function(event, ui) {
        exp.sliderPost = ui.value;
      });
    },

    log_responses : function() {
      exp.data_trials.push({
        "trial_type" : "one_slider",
        "response" : exp.sliderPost,
        "type" : this.stim.type,
        "id" : this.stim.id,
        "order" : order,
      });
    order = order + 1;
    }
  });

  slides.subj_info =  slide({
    name : "subj_info",
    submit : function(e){
      //if (e.preventDefault) e.preventDefault(); // I don't know what this means.
      exp.subj_data = {
        language : $("#language").val(),
        enjoyment : $("#enjoyment").val(),
        asses : $('input[name="assess"]:checked').val(),
        age : $("#age").val(),
        gender : $("#gender").val(),
        education : $("#education").val(),
        comments : $("#comments").val(),
        problems: $("#problems").val(),
        fairprice: $("#fairprice").val()
      };
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.thanks = slide({
    name : "thanks",
    start : function() {
      exp.data= {
          "trials" : exp.data_trials,
          "catch_trials" : exp.catch_trials,
          "system" : exp.system,
          // "order" : exp.order,
          "condition" : exp.condition,
          "subject_information" : exp.subj_data,
          "time_in_minutes" : (Date.now() - exp.startT)/60000
      };
      setTimeout(function() {turk.submit(exp.data);}, 1000);
    }
  });

  return slides;
}

/// init ///
function init() {
  exp.trials = [];
  exp.catch_trials = [];
  exp.condition = _.sample(["orprime_either", "orprime_notboth", "orprime_and"]); //can randomize between subject conditions here
  // exp.order = _.sample(["4fillerspacing","nofillerspacing"]);
  exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width
    };
  //blocks of the experiment:
  exp.structure=["i0", "consent", "instructions", "getready_practice", "practice_trials", "getready", "one_slider", 'subj_info', 'thanks'];

  exp.data_trials = [];
  //make corresponding slides:
  exp.slides = make_slides(exp);

  exp.nQs = utils.get_exp_length(); //this does not work if there are stacks of stims (but does work for an experiment with this structure)
                    //relies on structure and slides being defined

  $('.slide').hide(); //hide everything

  //make sure turkers have accepted HIT (or you're not in mturk)
  $("#start_button").click(function() {
    if (turk.previewMode) {
      $("#mustaccept").show();
    } else {
      $("#start_button").click(function() {$("#mustaccept").show();});
      exp.go();
    }
  });

  exp.go(); //show first slide
}
