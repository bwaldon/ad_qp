  var filler_block1 = [
    {type: "filler", sentence: "Calvin managed to pass his Spanish exam.", suggests: "It was difficult for Calvin to pass his Spanish exam"},
    {type: "filler", sentence: "Every basketball player except Lidia is over 6 feet tall.", suggests: "Lidia is a basketball player"},
    {type: "filler", sentence: "Maria gave birth to twins last week.", suggests: "Maria gave birth to two children last week"},
    {type: "filler", sentence: "Newtown has a population of less than 10,000.", suggests: "Less than 10,000 people live in Newtown"},];

  var filler_block2 = [
    {type: "filler", sentence: "Every professor except Professor Smith gave Ruchi an A this semester.", suggests: "Professor Smith gave Ruchi a grade lower than A this semester"},
    {type: "filler", sentence: "It finally rained in Watsonville on Thursday.", suggests: "Before Thursday, it had not rained in Watsonville in a long time"},
    {type: "filler", sentence: "Bill wants to study abroad in France next semester.", suggests: "Bill wants to study abroad in Paris next semester"},
    {type: "filler", sentence: "It must be raining outside right now.", suggests: "It's possible that it isn't raining outside right now"},];

  var condit_dict = { 
      or_eitherorprime : [
      {type: "prime", sentence: "Peter inherited either the painting or the wardrobe from his grandmother.", suggests: "Peter inherited only one of these things from his grandmother"},
      {type: "crit", sentence: "Joanne invited David or Sabine to the party.", suggests: "Joanne invited only one of these two people to the party"},
      ], 
      or_notbothprime : [
      {type: "prime", sentence: "Peter inherited the painting or the wardrobe from his grandmother, but not both.", suggests: "Peter inherited only one of these things from his grandmother"},
      {type: "crit", sentence: "Joanne invited David or Sabine to the party.", suggests: "Joanne invited only one of these two people to the party"},
      ],
      or_andprime : [
      {type: "prime", sentence: "Peter inherited the painting and the wardrobe from his grandmother.", suggests: "Peter inherited only one of these things from his grandmother"},
      {type: "crit", sentence: "Joanne invited David or Sabine to the party.", suggests: "Joanne invited only one of these two people to the party"},
      ],  
      or_noprime : [
      {type: "prime", sentence: "Peter inherited the painting from his grandmother, while John inherited the wardrobe.", suggests: "Peter inherited only one of these things from his grandmother"},
      {type: "crit", sentence: "Joanne invited David or Sabine to the party.", suggests: "Joanne invited only one of these two people to the party"},
      ],
     };

function make_slides(f) {
  var   slides = {};
  // var present_list = filler_block1.concat(condit_dict[exp.condition][0], filler_block2, condit_dict[exp.condition][1]);

  if (exp.order == "4fillerspacing") {
    var present_list = filler_block1.concat(condit_dict[exp.condition][0], filler_block2, condit_dict[exp.condition][1]);
  } else if (exp.order == "nofillerspacing") {
    var present_list = filler_block1.concat(condit_dict[exp.condition][0], condit_dict[exp.condition][1], filler_block2);
  } else {
    console.log("Order is undefined");
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

  slides.one_slider = slide({
    name : "one_slider",

    /* trial information for this block
     (the variable 'stim' will change between each of these values,
      and for each of these, present_handle will be run.) */

    present : present_list,

    //this gets run only at the beginning of the block
    present_handle : function(stim) {
      $(".err").hide();

      this.stim = stim; //I like to store this information in the slide so I can record it later.

      $(".prompt").html('"' + stim.sentence + '"' + "<p> <b> suggests </b> <p> <i> " + stim.suggests + ".</i>");
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
      });
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
          "order" : exp.order,
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
  exp.condition = _.sample(["or_eitherorprime", "or_andprime", "or_noprime", "or_notbothprime"]); //can randomize between subject conditions here
  exp.order = _.sample(["4fillerspacing","nofillerspacing"]);
  exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width
    };
  //blocks of the experiment:
  exp.structure=["i0", "consent", "instructions", "one_slider", 'subj_info', 'thanks'];

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
