  var filler_block1 = [
    {type: "filler", primetype : "na", target : "na", id: "low_right", fuckeditup: false, sentence: "A handful of people showed up to the meeting.", suggests: "Nobody showed up to the meeting"},
  
    {type: "filler", primetype : "na", target : "na", id: "high_right", fuckeditup: false, sentence: "The congressperson's hometown has a population of less than 10,000.", suggests: "Fewer than 10,000 people live in the congressperson's hometown"},];

var list1 = [ 

{type: "crit", primetype : "only", inference_question: "upperbounded", target : "some", id: "girls", sentence: "John talked to some of the girls in his class yesterday, and he talked to only some of the girls in his class today.", suggests: "John didn't talk to every girl in his class yesterday."},

];

var list2 = [

{type: "crit", primetype : "none", inference_question: "upperbounded", target : "some", id: "girls", sentence: "John talked to some of the girls in his class yesterday.", suggests: "John didn't talk to every girl in his class yesterday."},

];

var list3 = [

{type: "crit", primetype : "notall", inference_question: "upperbounded", target : "some", id: "girls", sentence: "John talked to some of the girls in his class yesterday, and he talked to some but not all of the girls in his class today.", suggests: "John didn't talk to every girl in his class yesterday."},

];

var list4 = [ 

{type: "crit", primetype : "only", inference_question: "lowerbounded", target : "some", id: "girls", sentence: "John talked to some of the girls in his class yesterday, and he talked to only some of the girls in his class today.", suggests: "John talked to every girl in his class yesterday."},

];

var list5 = [

{type: "crit", primetype : "none", inference_question: "lowerbounded", target : "some", id: "girls", sentence: "John talked to some of the girls in his class yesterday.", suggests: "John talked to every girl in his class yesterday."},

];

var list6 = [

{type: "crit", primetype : "notall", inference_question: "lowerbounded", target : "some", id: "girls", sentence: "John talked to some of the girls in his class yesterday, and he talked to some but not all of the girls in his class today.", suggests: "John talked to every girl in his class yesterday."},

];

 var lists_dict = [
    {name: "list1", items: list1},
    {name: "list2", items: list2},
    {name: "list3", items: list3},
    {name: "list4", items: list4},
    {name: "list5", items: list5},
    {name: "list6", items: list6},
  ];

var order = 1;

function make_slides(f) {
  var   slides = {};

  var present_list0 = _.shuffle((exp.condition).items);
  var present_list = [].concat.apply([], present_list0);

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
        // "race" : this.stim.race,
        "inference_question" : this.stim.inference_question,
        "primetype" : this.stim.primetype,
        "target" : this.stim.target,
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
        // "race" : this.stim.race,
        "inference_question" : this.stim.inference_question,
        "id" : this.stim.id,
        "primetype" : this.stim.primetype,
        "target" : this.stim.target,
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
          "list" : (exp.condition).name,
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
  exp.condition = _.sample(lists_dict); //can randomize between subject conditions here
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
