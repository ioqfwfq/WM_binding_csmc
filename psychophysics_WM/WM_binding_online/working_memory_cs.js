/************************** 
 * Working_Memory_Cs *
 **************************/

import { core, data, sound, util, visual, hardware } from './lib/psychojs-2024.2.4.js';
const { PsychoJS } = core;
const { TrialHandler, MultiStairHandler } = data;
const { Scheduler } = util;
//some handy aliases as in the psychopy scripts;
const { abs, sin, cos, PI: pi, sqrt } = Math;
const { round } = util;


// store info about the experiment session:
let expName = 'working_memory_cs';  // from the Builder filename that created this script
let expInfo = {
    'participant': `${util.pad(Number.parseFloat(util.randint(0, 999999)).toFixed(0), 6)}`,
    'session': '001',
};

// Start code blocks for 'Before Experiment'
// init psychoJS:
const psychoJS = new PsychoJS({
  debug: true
});

// open window:
psychoJS.openWindow({
  fullscr: false,
  color: new util.Color([-1, -1, -1]),
  units: 'height',
  waitBlanking: true,
  backgroundImage: '',
  backgroundFit: 'none',
});
// schedule the experiment:
psychoJS.schedule(psychoJS.gui.DlgFromDict({
  dictionary: expInfo,
  title: expName
}));

const flowScheduler = new Scheduler(psychoJS);
const dialogCancelScheduler = new Scheduler(psychoJS);
psychoJS.scheduleCondition(function() { return (psychoJS.gui.dialogComponent.button === 'OK'); },flowScheduler, dialogCancelScheduler);

// flowScheduler gets run if the participants presses OK
flowScheduler.add(updateInfo); // add timeStamp
flowScheduler.add(experimentInit);
flowScheduler.add(InstructionRoutineBegin());
flowScheduler.add(InstructionRoutineEachFrame());
flowScheduler.add(InstructionRoutineEnd());
flowScheduler.add(Instruction_0RoutineBegin());
flowScheduler.add(Instruction_0RoutineEachFrame());
flowScheduler.add(Instruction_0RoutineEnd());
const practice_trialsLoopScheduler = new Scheduler(psychoJS);
flowScheduler.add(practice_trialsLoopBegin(practice_trialsLoopScheduler));
flowScheduler.add(practice_trialsLoopScheduler);
flowScheduler.add(practice_trialsLoopEnd);


flowScheduler.add(StartRoutineBegin());
flowScheduler.add(StartRoutineEachFrame());
flowScheduler.add(StartRoutineEnd());
const trialsLoopScheduler = new Scheduler(psychoJS);
flowScheduler.add(trialsLoopBegin(trialsLoopScheduler));
flowScheduler.add(trialsLoopScheduler);
flowScheduler.add(trialsLoopEnd);



flowScheduler.add(thanksRoutineBegin());
flowScheduler.add(thanksRoutineEachFrame());
flowScheduler.add(thanksRoutineEnd());
flowScheduler.add(quitPsychoJS, '', true);

// quit if user presses Cancel in dialog box:
dialogCancelScheduler.add(quitPsychoJS, '', false);

psychoJS.start({
  expName: expName,
  expInfo: expInfo,
  resources: [
    // resources:
    {'name': 'conditions_practice.csv', 'path': 'conditions_practice.csv'},
    {'name': 'conditions_0.csv', 'path': 'conditions_0.csv'},
    {'name': 'keyG.png', 'path': 'keyG.png'},
    {'name': 'keyH.png', 'path': 'keyH.png'},
    {'name': 'keyJ.png', 'path': 'keyJ.png'},
    {'name': 'default.png', 'path': 'https://pavlovia.org/assets/default/default.png'},
    {'name': 'conditions_0.csv', 'path': 'conditions_0.csv'},
    {'name': 'keyJ.png', 'path': 'keyJ.png'},
    {'name': 'keyH.png', 'path': 'keyH.png'},
    {'name': 'keyG.png', 'path': 'keyG.png'},
    {'name': 'stimuli/Person/10.jpg', 'path': 'stimuli/Person/10.jpg'},
    {'name': 'stimuli/Person/11.jpg', 'path': 'stimuli/Person/11.jpg'},
    {'name': 'stimuli/Person/12.jpg', 'path': 'stimuli/Person/12.jpg'},
    {'name': 'stimuli/Person/13.jpg', 'path': 'stimuli/Person/13.jpg'},
    {'name': 'stimuli/Person/14.jpg', 'path': 'stimuli/Person/14.jpg'},
    {'name': 'stimuli/Person/15.jpg', 'path': 'stimuli/Person/15.jpg'},
    {'name': 'stimuli/Person/16.jpg', 'path': 'stimuli/Person/16.jpg'},
    {'name': 'stimuli/Person/17.jpg', 'path': 'stimuli/Person/17.jpg'},
    {'name': 'stimuli/Person/18.jpg', 'path': 'stimuli/Person/18.jpg'},
    {'name': 'stimuli/Person/19.jpg', 'path': 'stimuli/Person/19.jpg'},
    {'name': 'stimuli/Person/20.jpg', 'path': 'stimuli/Person/20.jpg'},
    {'name': 'stimuli/Person/21.jpg', 'path': 'stimuli/Person/21.jpg'},
    {'name': 'stimuli/Person/22.jpg', 'path': 'stimuli/Person/22.jpg'},
    {'name': 'stimuli/Person/23.jpg', 'path': 'stimuli/Person/23.jpg'},
    {'name': 'stimuli/Person/24.jpg', 'path': 'stimuli/Person/24.jpg'},
    {'name': 'stimuli/Person/25.jpg', 'path': 'stimuli/Person/25.jpg'},
    {'name': 'stimuli/Person/26.jpg', 'path': 'stimuli/Person/26.jpg'},
    {'name': 'stimuli/Person/27.jpg', 'path': 'stimuli/Person/27.jpg'},
    {'name': 'stimuli/Person/28.jpg', 'path': 'stimuli/Person/28.jpg'},
    {'name': 'stimuli/Person/29.jpg', 'path': 'stimuli/Person/29.jpg'},
    {'name': 'stimuli/Food/10.jpg', 'path': 'stimuli/Food/10.jpg'},
    {'name': 'stimuli/Food/11.jpg', 'path': 'stimuli/Food/11.jpg'},
    {'name': 'stimuli/Food/12.jpg', 'path': 'stimuli/Food/12.jpg'},
    {'name': 'stimuli/Food/13.jpg', 'path': 'stimuli/Food/13.jpg'},
    {'name': 'stimuli/Food/14.jpg', 'path': 'stimuli/Food/14.jpg'},
    {'name': 'stimuli/Food/15.jpg', 'path': 'stimuli/Food/15.jpg'},
    {'name': 'stimuli/Food/16.jpg', 'path': 'stimuli/Food/16.jpg'},
    {'name': 'stimuli/Food/17.jpg', 'path': 'stimuli/Food/17.jpg'},
    {'name': 'stimuli/Food/18.jpg', 'path': 'stimuli/Food/18.jpg'},
    {'name': 'stimuli/Food/19.jpg', 'path': 'stimuli/Food/19.jpg'},
    {'name': 'stimuli/Food/20.jpg', 'path': 'stimuli/Food/20.jpg'},
    {'name': 'stimuli/Food/21.jpg', 'path': 'stimuli/Food/21.jpg'},
    {'name': 'stimuli/Food/22.jpg', 'path': 'stimuli/Food/22.jpg'},
    {'name': 'stimuli/Food/23.jpg', 'path': 'stimuli/Food/23.jpg'},
    {'name': 'stimuli/Food/24.jpg', 'path': 'stimuli/Food/24.jpg'},
    {'name': 'stimuli/Food/25.jpg', 'path': 'stimuli/Food/25.jpg'},
    {'name': 'stimuli/Food/26.jpg', 'path': 'stimuli/Food/26.jpg'},
    {'name': 'stimuli/Food/27.jpg', 'path': 'stimuli/Food/27.jpg'},
    {'name': 'stimuli/Food/28.jpg', 'path': 'stimuli/Food/28.jpg'},
    {'name': 'stimuli/Food/29.jpg', 'path': 'stimuli/Food/29.jpg'},
    {'name': 'stimuli/Car/10.jpg', 'path': 'stimuli/Car/10.jpg'},
    {'name': 'stimuli/Car/11.jpg', 'path': 'stimuli/Car/11.jpg'},
    {'name': 'stimuli/Car/12.jpg', 'path': 'stimuli/Car/12.jpg'},
    {'name': 'stimuli/Car/13.jpg', 'path': 'stimuli/Car/13.jpg'},
    {'name': 'stimuli/Car/14.jpg', 'path': 'stimuli/Car/14.jpg'},
    {'name': 'stimuli/Car/15.jpg', 'path': 'stimuli/Car/15.jpg'},
    {'name': 'stimuli/Car/16.jpg', 'path': 'stimuli/Car/16.jpg'},
    {'name': 'stimuli/Car/17.jpg', 'path': 'stimuli/Car/17.jpg'},
    {'name': 'stimuli/Car/18.jpg', 'path': 'stimuli/Car/18.jpg'},
    {'name': 'stimuli/Car/19.jpg', 'path': 'stimuli/Car/19.jpg'},
    {'name': 'stimuli/Car/20.jpg', 'path': 'stimuli/Car/20.jpg'},
    {'name': 'stimuli/Car/21.jpg', 'path': 'stimuli/Car/21.jpg'},
    {'name': 'stimuli/Car/22.jpg', 'path': 'stimuli/Car/22.jpg'},
    {'name': 'stimuli/Car/23.jpg', 'path': 'stimuli/Car/23.jpg'},
    {'name': 'stimuli/Car/24.jpg', 'path': 'stimuli/Car/24.jpg'},
    {'name': 'stimuli/Car/25.jpg', 'path': 'stimuli/Car/25.jpg'},
    {'name': 'stimuli/Car/26.jpg', 'path': 'stimuli/Car/26.jpg'},
    {'name': 'stimuli/Car/27.jpg', 'path': 'stimuli/Car/27.jpg'},
    {'name': 'stimuli/Car/28.jpg', 'path': 'stimuli/Car/28.jpg'},
    {'name': 'stimuli/Car/29.jpg', 'path': 'stimuli/Car/29.jpg'},
    {'name': 'stimuli/Animal/10.jpg', 'path': 'stimuli/Animal/10.jpg'},
    {'name': 'stimuli/Animal/11.jpg', 'path': 'stimuli/Animal/11.jpg'},
    {'name': 'stimuli/Animal/12.jpg', 'path': 'stimuli/Animal/12.jpg'},
    {'name': 'stimuli/Animal/13.jpg', 'path': 'stimuli/Animal/13.jpg'},
    {'name': 'stimuli/Animal/14.jpg', 'path': 'stimuli/Animal/14.jpg'},
    {'name': 'stimuli/Animal/15.jpg', 'path': 'stimuli/Animal/15.jpg'},
    {'name': 'stimuli/Animal/16.jpg', 'path': 'stimuli/Animal/16.jpg'},
    {'name': 'stimuli/Animal/17.jpg', 'path': 'stimuli/Animal/17.jpg'},
    {'name': 'stimuli/Animal/18.jpg', 'path': 'stimuli/Animal/18.jpg'},
    {'name': 'stimuli/Animal/19.jpg', 'path': 'stimuli/Animal/19.jpg'},
    {'name': 'stimuli/Animal/20.jpg', 'path': 'stimuli/Animal/20.jpg'},
    {'name': 'stimuli/Animal/21.jpg', 'path': 'stimuli/Animal/21.jpg'},
    {'name': 'stimuli/Animal/22.jpg', 'path': 'stimuli/Animal/22.jpg'},
    {'name': 'stimuli/Animal/23.jpg', 'path': 'stimuli/Animal/23.jpg'},
    {'name': 'stimuli/Animal/24.jpg', 'path': 'stimuli/Animal/24.jpg'},
    {'name': 'stimuli/Animal/25.jpg', 'path': 'stimuli/Animal/25.jpg'},
    {'name': 'stimuli/Animal/26.jpg', 'path': 'stimuli/Animal/26.jpg'},
    {'name': 'stimuli/Animal/27.jpg', 'path': 'stimuli/Animal/27.jpg'},
    {'name': 'stimuli/Animal/28.jpg', 'path': 'stimuli/Animal/28.jpg'},
    {'name': 'stimuli/Animal/29.jpg', 'path': 'stimuli/Animal/29.jpg'},
  ]
});

psychoJS.experimentLogger.setLevel(core.Logger.ServerLevel.EXP);


var currentLoop;
var frameDur;
async function updateInfo() {
  currentLoop = psychoJS.experiment;  // right now there are no loops
  expInfo['date'] = util.MonotonicClock.getDateStr();  // add a simple timestamp
  expInfo['expName'] = expName;
  expInfo['psychopyVersion'] = '2024.2.4';
  expInfo['OS'] = window.navigator.platform;


  // store frame rate of monitor if we can measure it successfully
  expInfo['frameRate'] = psychoJS.window.getActualFrameRate();
  if (typeof expInfo['frameRate'] !== 'undefined')
    frameDur = 1.0 / Math.round(expInfo['frameRate']);
  else
    frameDur = 1.0 / 60.0; // couldn't get a reliable measure so guess

  // add info from the URL:
  util.addInfoFromUrl(expInfo);
  

  
  psychoJS.experiment.dataFileName = (("." + "/") + `data/${expInfo["participant"]}_${expName}_${expInfo["date"]}`);
  psychoJS.experiment.field_separator = '\t';


  return Scheduler.Event.NEXT;
}


var InstructionClock;
var instructionKey0;
var instruction_txt_pre;
var Instruction_0Clock;
var instructionKey1;
var instruction_txt_up;
var instruction_txt_bot;
var keyG;
var keyH;
var keyJ;
var textboxG;
var textboxH;
var textboxJ;
var PracticeClock;
var options;
var options_color;
var options_loc;
var option_texts;
var pactice_text;
var fixation_pra;
var stim1_pra;
var delay1_pra;
var stim2_pra;
var delay2_pra;
var probe_pra;
var option1_pra;
var option2_pra;
var option3_pra;
var key_resp1_pra;
var StartClock;
var instruction_txt;
var startKey;
var keyG_3;
var keyH_3;
var keyJ_3;
var textboxG_3;
var textboxH_3;
var textboxJ_3;
var trialClock;
var fixation;
var stim1;
var delay1;
var stim2;
var delay2;
var probe;
var option1;
var option2;
var option3;
var key_resp;
var break_textClock;
var text_break;
var key_resp_break;
var keyG_2;
var keyH_2;
var keyJ_2;
var textboxG_2;
var textboxH_2;
var textboxJ_2;
var thanksClock;
var endmsg;
var globalClock;
var routineTimer;
async function experimentInit() {
  // Initialize components for Routine "Instruction"
  InstructionClock = new util.Clock();
  instructionKey0 = new core.Keyboard({psychoJS: psychoJS, clock: new util.Clock(), waitForStart: true});
  
  instruction_txt_pre = new visual.TextBox({
    win: psychoJS.window,
    name: 'instruction_txt_pre',
    text: '\nWelcome to the Working Memory Task.\n\nYou will see two pictures of people, animals, food  or cars in each trial. After a short delay, you will be asked a question about one (earlier/later) of the images.\n\nPress SPACE to continue.',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [0, 0.1], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [1, 0.8],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: 'black', borderColor: 'black',
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: 0.8,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -1.0 
  });
  
  // Initialize components for Routine "Instruction_0"
  Instruction_0Clock = new util.Clock();
  instructionKey1 = new core.Keyboard({psychoJS: psychoJS, clock: new util.Clock(), waitForStart: true});
  
  instruction_txt_up = new visual.TextBox({
    win: psychoJS.window,
    name: 'instruction_txt_up',
    text: '\nThere are 3 options at the left, top and right of the question.\n\nPlease use keys',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [0, 0.25], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [1, 0.8],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: 'black', borderColor: 'black',
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: 0.8,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -1.0 
  });
  
  instruction_txt_bot = new visual.TextBox({
    win: psychoJS.window,
    name: 'instruction_txt_bot',
    text: 'to choose your answers\n\nPress SPACE to practice!',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [0, (- 0.25)], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [1, 0.8],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: 'black', borderColor: 'black',
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: 0.8,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -2.0 
  });
  
  keyG = new visual.ImageStim({
    win : psychoJS.window,
    name : 'keyG', units : undefined, 
    image : 'keyG.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, 
    pos : [(- 0.25), 0], 
    draggable: false,
    size : [0.15, 0.15],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -3.0 
  });
  keyH = new visual.ImageStim({
    win : psychoJS.window,
    name : 'keyH', units : undefined, 
    image : 'keyH.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, 
    pos : [(- 0), 0], 
    draggable: false,
    size : [0.15, 0.15],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -4.0 
  });
  keyJ = new visual.ImageStim({
    win : psychoJS.window,
    name : 'keyJ', units : undefined, 
    image : 'keyJ.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, 
    pos : [0.25, 0], 
    draggable: false,
    size : [0.15, 0.15],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -5.0 
  });
  textboxG = new visual.TextBox({
    win: psychoJS.window,
    name: 'textboxG',
    text: 'Left',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [(- 0.25), (- 0.1)], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [0.4, 0.4],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: undefined, borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -6.0 
  });
  
  textboxH = new visual.TextBox({
    win: psychoJS.window,
    name: 'textboxH',
    text: 'Top',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [(- 0), (- 0.1)], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [0.4, 0.4],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: undefined, borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -7.0 
  });
  
  textboxJ = new visual.TextBox({
    win: psychoJS.window,
    name: 'textboxJ',
    text: 'Right',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [0.25, (- 0.1)], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [0.4, 0.4],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: undefined, borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -8.0 
  });
  
  // Initialize components for Routine "Practice"
  PracticeClock = new util.Clock();
  // Run 'Begin Experiment' code from trial_condition_pra
  options = [" 0 ", " 1 ", " 5 "];
  options_color = [[0, 0.8, 0], [0, 0, 0.8], [0.8, 0, 0]];
  options_loc = [[(- 0.5), 0], [0, 0.2], [0.5, 0]];
  option_texts = [];
  for (var i, _pj_c = 0, _pj_a = util.range(options.length), _pj_b = _pj_a.length; (_pj_c < _pj_b); _pj_c += 1) {
      i = _pj_a[_pj_c];
      option_texts.push({"text": `${options[i]}`, "color": options_color[i], "pos": options_loc[i]});
  }
  
  pactice_text = new visual.TextStim({
    win: psychoJS.window,
    name: 'pactice_text',
    text: 'Practice trial',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0.4], draggable: false, height: 0.025,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -1.0 
  });
  
  fixation_pra = new visual.TextStim({
    win: psychoJS.window,
    name: 'fixation_pra',
    text: '+',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.1,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -2.0 
  });
  
  stim1_pra = new visual.ImageStim({
    win : psychoJS.window,
    name : 'stim1_pra', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0, 
    pos : [0, 0], 
    draggable: false,
    size : [0.6, 0.4],
    color : new util.Color('white'), opacity : 1,
    flipHoriz : false, flipVert : false,
    texRes : 128, interpolate : true, depth : -3.0 
  });
  delay1_pra = new visual.TextStim({
    win: psychoJS.window,
    name: 'delay1_pra',
    text: 'HOLD',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.05,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -4.0 
  });
  
  stim2_pra = new visual.ImageStim({
    win : psychoJS.window,
    name : 'stim2_pra', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0, 
    pos : [0, 0], 
    draggable: false,
    size : [0.6, 0.4],
    color : new util.Color('white'), opacity : 1,
    flipHoriz : false, flipVert : false,
    texRes : 128, interpolate : true, depth : -5.0 
  });
  delay2_pra = new visual.TextStim({
    win: psychoJS.window,
    name: 'delay2_pra',
    text: 'HOLD',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.05,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -6.0 
  });
  
  probe_pra = new visual.TextStim({
    win: psychoJS.window,
    name: 'probe_pra',
    text: '',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.05,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -7.0 
  });
  
  option1_pra = new visual.TextStim({
    win: psychoJS.window,
    name: 'option1_pra',
    text: '',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.1,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -8.0 
  });
  
  option2_pra = new visual.TextStim({
    win: psychoJS.window,
    name: 'option2_pra',
    text: '',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.1,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -9.0 
  });
  
  option3_pra = new visual.TextStim({
    win: psychoJS.window,
    name: 'option3_pra',
    text: '',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.1,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -10.0 
  });
  
  key_resp1_pra = new core.Keyboard({psychoJS: psychoJS, clock: new util.Clock(), waitForStart: true});
  
  // Initialize components for Routine "Start"
  StartClock = new util.Clock();
  instruction_txt = new visual.TextBox({
    win: psychoJS.window,
    name: 'instruction_txt',
    text: 'Press SPACE to start the task!',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [0, 0.1], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [1, 0.8],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: 'black', borderColor: 'black',
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: 0.8,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: 0.0 
  });
  
  startKey = new core.Keyboard({psychoJS: psychoJS, clock: new util.Clock(), waitForStart: true});
  
  keyG_3 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'keyG_3', units : undefined, 
    image : 'keyG.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, 
    pos : [(- 0.25), (- 0.1)], 
    draggable: false,
    size : [0.15, 0.15],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -2.0 
  });
  keyH_3 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'keyH_3', units : undefined, 
    image : 'keyH.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, 
    pos : [(- 0), (- 0.1)], 
    draggable: false,
    size : [0.15, 0.15],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -3.0 
  });
  keyJ_3 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'keyJ_3', units : undefined, 
    image : 'keyJ.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, 
    pos : [0.25, (- 0.1)], 
    draggable: false,
    size : [0.15, 0.15],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -4.0 
  });
  textboxG_3 = new visual.TextBox({
    win: psychoJS.window,
    name: 'textboxG_3',
    text: 'Left',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [(- 0.25), (- 0.2)], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [0.4, 0.4],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: undefined, borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -5.0 
  });
  
  textboxH_3 = new visual.TextBox({
    win: psychoJS.window,
    name: 'textboxH_3',
    text: 'Top',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [(- 0), (- 0.2)], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [0.4, 0.4],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: undefined, borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -6.0 
  });
  
  textboxJ_3 = new visual.TextBox({
    win: psychoJS.window,
    name: 'textboxJ_3',
    text: 'Right',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [0.25, (- 0.2)], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [0.4, 0.4],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: undefined, borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -7.0 
  });
  
  // Initialize components for Routine "trial"
  trialClock = new util.Clock();
  fixation = new visual.TextStim({
    win: psychoJS.window,
    name: 'fixation',
    text: '+',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.1,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -1.0 
  });
  
  stim1 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'stim1', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0, 
    pos : [0, 0], 
    draggable: false,
    size : [0.6, 0.4],
    color : new util.Color('white'), opacity : 1,
    flipHoriz : false, flipVert : false,
    texRes : 128, interpolate : true, depth : -2.0 
  });
  delay1 = new visual.TextStim({
    win: psychoJS.window,
    name: 'delay1',
    text: 'HOLD',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.05,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -3.0 
  });
  
  stim2 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'stim2', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0, 
    pos : [0, 0], 
    draggable: false,
    size : [0.6, 0.4],
    color : new util.Color('white'), opacity : 1,
    flipHoriz : false, flipVert : false,
    texRes : 128, interpolate : true, depth : -4.0 
  });
  delay2 = new visual.TextStim({
    win: psychoJS.window,
    name: 'delay2',
    text: 'HOLD',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.05,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -5.0 
  });
  
  probe = new visual.TextStim({
    win: psychoJS.window,
    name: 'probe',
    text: '',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.05,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -6.0 
  });
  
  option1 = new visual.TextStim({
    win: psychoJS.window,
    name: 'option1',
    text: '',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.1,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -7.0 
  });
  
  option2 = new visual.TextStim({
    win: psychoJS.window,
    name: 'option2',
    text: '',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.1,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -8.0 
  });
  
  option3 = new visual.TextStim({
    win: psychoJS.window,
    name: 'option3',
    text: '',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0], draggable: false, height: 0.1,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -9.0 
  });
  
  key_resp = new core.Keyboard({psychoJS: psychoJS, clock: new util.Clock(), waitForStart: true});
  
  // Initialize components for Routine "break_text"
  break_textClock = new util.Clock();
  text_break = new visual.TextStim({
    win: psychoJS.window,
    name: 'text_break',
    text: '',
    font: 'Arial',
    units: undefined, 
    pos: [0, 0.1], draggable: false, height: 0.05,  wrapWidth: undefined, ori: 0.0,
    languageStyle: 'LTR',
    color: new util.Color('white'),  opacity: undefined,
    depth: -1.0 
  });
  
  key_resp_break = new core.Keyboard({psychoJS: psychoJS, clock: new util.Clock(), waitForStart: true});
  
  keyG_2 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'keyG_2', units : undefined, 
    image : 'keyG.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, 
    pos : [(- 0.25), (- 0.1)], 
    draggable: false,
    size : [0.15, 0.15],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -3.0 
  });
  keyH_2 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'keyH_2', units : undefined, 
    image : 'keyH.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, 
    pos : [(- 0), (- 0.1)], 
    draggable: false,
    size : [0.15, 0.15],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -4.0 
  });
  keyJ_2 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'keyJ_2', units : undefined, 
    image : 'keyJ.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, 
    pos : [0.25, (- 0.1)], 
    draggable: false,
    size : [0.15, 0.15],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -5.0 
  });
  textboxG_2 = new visual.TextBox({
    win: psychoJS.window,
    name: 'textboxG_2',
    text: 'Left',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [(- 0.25), (- 0.2)], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [0.4, 0.4],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: undefined, borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -6.0 
  });
  
  textboxH_2 = new visual.TextBox({
    win: psychoJS.window,
    name: 'textboxH_2',
    text: 'Top',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [(- 0), (- 0.2)], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [0.4, 0.4],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: undefined, borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -7.0 
  });
  
  textboxJ_2 = new visual.TextBox({
    win: psychoJS.window,
    name: 'textboxJ_2',
    text: 'Right',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [0.25, (- 0.2)], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [0.4, 0.4],  units: undefined, 
    ori: 0.0,
    color: 'white', colorSpace: 'rgb',
    fillColor: undefined, borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -8.0 
  });
  
  // Initialize components for Routine "thanks"
  thanksClock = new util.Clock();
  endmsg = new visual.TextBox({
    win: psychoJS.window,
    name: 'endmsg',
    text: 'This is the end of the experiment.\n\nThanks for taking part!',
    placeholder: 'Type here...',
    font: 'Arial',
    pos: [0, 0], 
    draggable: false,
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [1, 0.8],  units: undefined, 
    ori: 0.0,
    color: 'black', colorSpace: 'rgb',
    fillColor: 'white', borderColor: 'black',
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: 0.8,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: 0.0 
  });
  
  // Create some handy timers
  globalClock = new util.Clock();  // to track the time since experiment started
  routineTimer = new util.CountdownTimer();  // to track time remaining of each (non-slip) routine
  
  return Scheduler.Event.NEXT;
}


var t;
var frameN;
var continueRoutine;
var InstructionMaxDurationReached;
var _instructionKey0_allKeys;
var InstructionMaxDuration;
var InstructionComponents;
function InstructionRoutineBegin(snapshot) {
  return async function () {
    TrialHandler.fromSnapshot(snapshot); // ensure that .thisN vals are up to date
    
    //--- Prepare to start Routine 'Instruction' ---
    t = 0;
    frameN = -1;
    continueRoutine = true; // until we're told otherwise
    InstructionClock.reset();
    routineTimer.reset();
    InstructionMaxDurationReached = false;
    // update component parameters for each repeat
    instructionKey0.keys = undefined;
    instructionKey0.rt = undefined;
    _instructionKey0_allKeys = [];
    psychoJS.experiment.addData('Instruction.started', globalClock.getTime());
    InstructionMaxDuration = null
    // keep track of which components have finished
    InstructionComponents = [];
    InstructionComponents.push(instructionKey0);
    InstructionComponents.push(instruction_txt_pre);
    
    for (const thisComponent of InstructionComponents)
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
    return Scheduler.Event.NEXT;
  }
}


function InstructionRoutineEachFrame() {
  return async function () {
    //--- Loop for each frame of Routine 'Instruction' ---
    // get current time
    t = InstructionClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *instructionKey0* updates
    if (t >= 0.0 && instructionKey0.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      instructionKey0.tStart = t;  // (not accounting for frame time here)
      instructionKey0.frameNStart = frameN;  // exact frame index
      
      // keyboard checking is just starting
      psychoJS.window.callOnFlip(function() { instructionKey0.clock.reset(); });  // t=0 on next screen flip
      psychoJS.window.callOnFlip(function() { instructionKey0.start(); }); // start on screen flip
      psychoJS.window.callOnFlip(function() { instructionKey0.clearEvents(); });
    }
    
    if (instructionKey0.status === PsychoJS.Status.STARTED) {
      let theseKeys = instructionKey0.getKeys({keyList: ['space'], waitRelease: false});
      _instructionKey0_allKeys = _instructionKey0_allKeys.concat(theseKeys);
      if (_instructionKey0_allKeys.length > 0) {
        instructionKey0.keys = _instructionKey0_allKeys[_instructionKey0_allKeys.length - 1].name;  // just the last key pressed
        instructionKey0.rt = _instructionKey0_allKeys[_instructionKey0_allKeys.length - 1].rt;
        instructionKey0.duration = _instructionKey0_allKeys[_instructionKey0_allKeys.length - 1].duration;
        // a response ends the routine
        continueRoutine = false;
      }
    }
    
    
    // *instruction_txt_pre* updates
    if (t >= 0.0 && instruction_txt_pre.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      instruction_txt_pre.tStart = t;  // (not accounting for frame time here)
      instruction_txt_pre.frameNStart = frameN;  // exact frame index
      
      instruction_txt_pre.setAutoDraw(true);
    }
    
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    for (const thisComponent of InstructionComponents)
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
        break;
      }
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function InstructionRoutineEnd(snapshot) {
  return async function () {
    //--- Ending Routine 'Instruction' ---
    for (const thisComponent of InstructionComponents) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    }
    psychoJS.experiment.addData('Instruction.stopped', globalClock.getTime());
    instructionKey0.stop();
    // the Routine "Instruction" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    // Routines running outside a loop should always advance the datafile row
    if (currentLoop === psychoJS.experiment) {
      psychoJS.experiment.nextEntry(snapshot);
    }
    return Scheduler.Event.NEXT;
  }
}


var Instruction_0MaxDurationReached;
var _instructionKey1_allKeys;
var Instruction_0MaxDuration;
var Instruction_0Components;
function Instruction_0RoutineBegin(snapshot) {
  return async function () {
    TrialHandler.fromSnapshot(snapshot); // ensure that .thisN vals are up to date
    
    //--- Prepare to start Routine 'Instruction_0' ---
    t = 0;
    frameN = -1;
    continueRoutine = true; // until we're told otherwise
    Instruction_0Clock.reset();
    routineTimer.reset();
    Instruction_0MaxDurationReached = false;
    // update component parameters for each repeat
    instructionKey1.keys = undefined;
    instructionKey1.rt = undefined;
    _instructionKey1_allKeys = [];
    Instruction_0MaxDuration = null
    // keep track of which components have finished
    Instruction_0Components = [];
    Instruction_0Components.push(instructionKey1);
    Instruction_0Components.push(instruction_txt_up);
    Instruction_0Components.push(instruction_txt_bot);
    Instruction_0Components.push(keyG);
    Instruction_0Components.push(keyH);
    Instruction_0Components.push(keyJ);
    Instruction_0Components.push(textboxG);
    Instruction_0Components.push(textboxH);
    Instruction_0Components.push(textboxJ);
    
    for (const thisComponent of Instruction_0Components)
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
    return Scheduler.Event.NEXT;
  }
}


function Instruction_0RoutineEachFrame() {
  return async function () {
    //--- Loop for each frame of Routine 'Instruction_0' ---
    // get current time
    t = Instruction_0Clock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *instructionKey1* updates
    if (t >= 0.0 && instructionKey1.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      instructionKey1.tStart = t;  // (not accounting for frame time here)
      instructionKey1.frameNStart = frameN;  // exact frame index
      
      // keyboard checking is just starting
      psychoJS.window.callOnFlip(function() { instructionKey1.clock.reset(); });  // t=0 on next screen flip
      psychoJS.window.callOnFlip(function() { instructionKey1.start(); }); // start on screen flip
      psychoJS.window.callOnFlip(function() { instructionKey1.clearEvents(); });
    }
    
    if (instructionKey1.status === PsychoJS.Status.STARTED) {
      let theseKeys = instructionKey1.getKeys({keyList: ['space'], waitRelease: false});
      _instructionKey1_allKeys = _instructionKey1_allKeys.concat(theseKeys);
      if (_instructionKey1_allKeys.length > 0) {
        instructionKey1.keys = _instructionKey1_allKeys[_instructionKey1_allKeys.length - 1].name;  // just the last key pressed
        instructionKey1.rt = _instructionKey1_allKeys[_instructionKey1_allKeys.length - 1].rt;
        instructionKey1.duration = _instructionKey1_allKeys[_instructionKey1_allKeys.length - 1].duration;
        // a response ends the routine
        continueRoutine = false;
      }
    }
    
    
    // *instruction_txt_up* updates
    if (t >= 0.0 && instruction_txt_up.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      instruction_txt_up.tStart = t;  // (not accounting for frame time here)
      instruction_txt_up.frameNStart = frameN;  // exact frame index
      
      instruction_txt_up.setAutoDraw(true);
    }
    
    
    // *instruction_txt_bot* updates
    if (t >= 0.0 && instruction_txt_bot.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      instruction_txt_bot.tStart = t;  // (not accounting for frame time here)
      instruction_txt_bot.frameNStart = frameN;  // exact frame index
      
      instruction_txt_bot.setAutoDraw(true);
    }
    
    
    // *keyG* updates
    if (t >= 0.0 && keyG.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      keyG.tStart = t;  // (not accounting for frame time here)
      keyG.frameNStart = frameN;  // exact frame index
      
      keyG.setAutoDraw(true);
    }
    
    
    // *keyH* updates
    if (t >= 0.0 && keyH.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      keyH.tStart = t;  // (not accounting for frame time here)
      keyH.frameNStart = frameN;  // exact frame index
      
      keyH.setAutoDraw(true);
    }
    
    
    // *keyJ* updates
    if (t >= 0.0 && keyJ.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      keyJ.tStart = t;  // (not accounting for frame time here)
      keyJ.frameNStart = frameN;  // exact frame index
      
      keyJ.setAutoDraw(true);
    }
    
    
    // *textboxG* updates
    if (t >= 0.0 && textboxG.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      textboxG.tStart = t;  // (not accounting for frame time here)
      textboxG.frameNStart = frameN;  // exact frame index
      
      textboxG.setAutoDraw(true);
    }
    
    
    // *textboxH* updates
    if (t >= 0.0 && textboxH.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      textboxH.tStart = t;  // (not accounting for frame time here)
      textboxH.frameNStart = frameN;  // exact frame index
      
      textboxH.setAutoDraw(true);
    }
    
    
    // *textboxJ* updates
    if (t >= 0.0 && textboxJ.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      textboxJ.tStart = t;  // (not accounting for frame time here)
      textboxJ.frameNStart = frameN;  // exact frame index
      
      textboxJ.setAutoDraw(true);
    }
    
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    for (const thisComponent of Instruction_0Components)
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
        break;
      }
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function Instruction_0RoutineEnd(snapshot) {
  return async function () {
    //--- Ending Routine 'Instruction_0' ---
    for (const thisComponent of Instruction_0Components) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    }
    instructionKey1.stop();
    // the Routine "Instruction_0" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    // Routines running outside a loop should always advance the datafile row
    if (currentLoop === psychoJS.experiment) {
      psychoJS.experiment.nextEntry(snapshot);
    }
    return Scheduler.Event.NEXT;
  }
}


var practice_trials;
function practice_trialsLoopBegin(practice_trialsLoopScheduler, snapshot) {
  return async function() {
    TrialHandler.fromSnapshot(snapshot); // update internal variables (.thisN etc) of the loop
    
    // set up handler to look after randomisation of conditions etc
    practice_trials = new TrialHandler({
      psychoJS: psychoJS,
      nReps: 1, method: TrialHandler.Method.SEQUENTIAL,
      extraInfo: expInfo, originPath: undefined,
      trialList: 'conditions_practice.csv',
      seed: undefined, name: 'practice_trials'
    });
    psychoJS.experiment.addLoop(practice_trials); // add the loop to the experiment
    currentLoop = practice_trials;  // we're now the current loop
    
    // Schedule all the trials in the trialList:
    for (const thisPractice_trial of practice_trials) {
      snapshot = practice_trials.getSnapshot();
      practice_trialsLoopScheduler.add(importConditions(snapshot));
      practice_trialsLoopScheduler.add(PracticeRoutineBegin(snapshot));
      practice_trialsLoopScheduler.add(PracticeRoutineEachFrame());
      practice_trialsLoopScheduler.add(PracticeRoutineEnd(snapshot));
      practice_trialsLoopScheduler.add(practice_trialsLoopEndIteration(practice_trialsLoopScheduler, snapshot));
    }
    
    return Scheduler.Event.NEXT;
  }
}


async function practice_trialsLoopEnd() {
  // terminate loop
  psychoJS.experiment.removeLoop(practice_trials);
  // update the current loop from the ExperimentHandler
  if (psychoJS.experiment._unfinishedLoops.length>0)
    currentLoop = psychoJS.experiment._unfinishedLoops.at(-1);
  else
    currentLoop = psychoJS.experiment;  // so we use addData from the experiment
  return Scheduler.Event.NEXT;
}


function practice_trialsLoopEndIteration(scheduler, snapshot) {
  // ------Prepare for next entry------
  return async function () {
    if (typeof snapshot !== 'undefined') {
      // ------Check if user ended loop early------
      if (snapshot.finished) {
        // Check for and save orphaned data
        if (psychoJS.experiment.isEntryEmpty()) {
          psychoJS.experiment.nextEntry(snapshot);
        }
        scheduler.stop();
      }
    return Scheduler.Event.NEXT;
    }
  };
}


var trials;
function trialsLoopBegin(trialsLoopScheduler, snapshot) {
  return async function() {
    TrialHandler.fromSnapshot(snapshot); // update internal variables (.thisN etc) of the loop
    
    // set up handler to look after randomisation of conditions etc
    trials = new TrialHandler({
      psychoJS: psychoJS,
      nReps: 1, method: TrialHandler.Method.SEQUENTIAL,
      extraInfo: expInfo, originPath: undefined,
      trialList: 'conditions_0.csv',
      seed: undefined, name: 'trials'
    });
    psychoJS.experiment.addLoop(trials); // add the loop to the experiment
    currentLoop = trials;  // we're now the current loop
    
    // Schedule all the trials in the trialList:
    for (const thisTrial of trials) {
      snapshot = trials.getSnapshot();
      trialsLoopScheduler.add(importConditions(snapshot));
      trialsLoopScheduler.add(trialRoutineBegin(snapshot));
      trialsLoopScheduler.add(trialRoutineEachFrame());
      trialsLoopScheduler.add(trialRoutineEnd(snapshot));
      trialsLoopScheduler.add(break_textRoutineBegin(snapshot));
      trialsLoopScheduler.add(break_textRoutineEachFrame());
      trialsLoopScheduler.add(break_textRoutineEnd(snapshot));
      trialsLoopScheduler.add(trialsLoopEndIteration(trialsLoopScheduler, snapshot));
    }
    
    return Scheduler.Event.NEXT;
  }
}


async function trialsLoopEnd() {
  // terminate loop
  psychoJS.experiment.removeLoop(trials);
  // update the current loop from the ExperimentHandler
  if (psychoJS.experiment._unfinishedLoops.length>0)
    currentLoop = psychoJS.experiment._unfinishedLoops.at(-1);
  else
    currentLoop = psychoJS.experiment;  // so we use addData from the experiment
  return Scheduler.Event.NEXT;
}


function trialsLoopEndIteration(scheduler, snapshot) {
  // ------Prepare for next entry------
  return async function () {
    if (typeof snapshot !== 'undefined') {
      // ------Check if user ended loop early------
      if (snapshot.finished) {
        // Check for and save orphaned data
        if (psychoJS.experiment.isEntryEmpty()) {
          psychoJS.experiment.nextEntry(snapshot);
        }
        scheduler.stop();
      } else {
        psychoJS.experiment.nextEntry(snapshot);
      }
    return Scheduler.Event.NEXT;
    }
  };
}


var PracticeMaxDurationReached;
var _pj;
var categories;
var positions;
var pic1;
var pic2;
var position_text;
var same_category;
var different_category;
var category_text;
var probe_text;
var _key_resp1_pra_allKeys;
var PracticeMaxDuration;
var PracticeComponents;
function PracticeRoutineBegin(snapshot) {
  return async function () {
    TrialHandler.fromSnapshot(snapshot); // ensure that .thisN vals are up to date
    
    //--- Prepare to start Routine 'Practice' ---
    t = 0;
    frameN = -1;
    continueRoutine = true; // until we're told otherwise
    PracticeClock.reset();
    routineTimer.reset();
    PracticeMaxDurationReached = false;
    // update component parameters for each repeat
    // Run 'Begin Routine' code from trial_condition_pra
    var _pj;
    function _pj_snippets(container) {
        function in_es6(left, right) {
            if (((right instanceof Array) || ((typeof right) === "string"))) {
                return (right.indexOf(left) > (- 1));
            } else {
                if (((right instanceof Map) || (right instanceof Set) || (right instanceof WeakMap) || (right instanceof WeakSet))) {
                    return right.has(left);
                } else {
                    return (left in right);
                }
            }
        }
        container["in_es6"] = in_es6;
        return container;
    }
    _pj = {};
    _pj_snippets(_pj);
    categories = {[1]: ["stimuli/Person/", "people"], [2]: ["stimuli/Animal/", "animals"], [3]: ["stimuli/Food/", "food items"], [4]: ["stimuli/Car/", "cars"]};
    positions = {[1]: "Earlier", [2]: "Later"};
    pic1 = `${categories[first_cat][0]}${first_pic_idx}.jpg`;
    pic2 = `${categories[second_cat][0]}${second_pic_idx}.jpg`;
    if (_pj.in_es6(probe_pic, positions)) {
        position_text = positions[probe_pic];
        if ((first_cat === second_cat)) {
            same_category = first_cat;
            different_category = same_category;
            if ((probe_validity === 1)) {
                category_text = categories[same_category][1];
            } else {
                if ((probe_validity === 0)) {
                    different_category = (5 - same_category);
                    category_text = categories[different_category][1];
                }
            }
        } else {
            if ((probe_validity === 1)) {
                if ((probe_pic === 1)) {
                    category_text = categories[first_cat][1];
                } else {
                    category_text = categories[second_cat][1];
                }
            } else {
                if ((probe_pic === 1)) {
                    category_text = categories[second_cat][1];
                } else {
                    category_text = categories[first_cat][1];
                }
            }
        }
        probe_text = (((position_text + " picture, how many ") + category_text) + "?");
    } else {
        probe_text = "Invalid probe picture condition.";
    }
    
    stim1_pra.setImage(pic1);
    stim2_pra.setImage(pic2);
    probe_pra.setText(probe_text);
    option1_pra.setColor(new util.Color(option_texts[0]['color']));
    option1_pra.setPos(option_texts[0]["pos"]);
    option1_pra.setText(option_texts[0]["text"]);
    option2_pra.setColor(new util.Color(option_texts[1]['color']));
    option2_pra.setPos(option_texts[1]["pos"]);
    option2_pra.setText(option_texts[1]["text"]);
    option3_pra.setColor(new util.Color(option_texts[2]['color']));
    option3_pra.setPos(option_texts[2]["pos"]);
    option3_pra.setText(option_texts[2]["text"]);
    key_resp1_pra.keys = undefined;
    key_resp1_pra.rt = undefined;
    _key_resp1_pra_allKeys = [];
    psychoJS.experiment.addData('Practice.started', globalClock.getTime());
    PracticeMaxDuration = null
    // keep track of which components have finished
    PracticeComponents = [];
    PracticeComponents.push(pactice_text);
    PracticeComponents.push(fixation_pra);
    PracticeComponents.push(stim1_pra);
    PracticeComponents.push(delay1_pra);
    PracticeComponents.push(stim2_pra);
    PracticeComponents.push(delay2_pra);
    PracticeComponents.push(probe_pra);
    PracticeComponents.push(option1_pra);
    PracticeComponents.push(option2_pra);
    PracticeComponents.push(option3_pra);
    PracticeComponents.push(key_resp1_pra);
    
    for (const thisComponent of PracticeComponents)
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
    return Scheduler.Event.NEXT;
  }
}


var frameRemains;
function PracticeRoutineEachFrame() {
  return async function () {
    //--- Loop for each frame of Routine 'Practice' ---
    // get current time
    t = PracticeClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *pactice_text* updates
    if (t >= 0.0 && pactice_text.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      pactice_text.tStart = t;  // (not accounting for frame time here)
      pactice_text.frameNStart = frameN;  // exact frame index
      
      pactice_text.setAutoDraw(true);
    }
    
    
    // *fixation_pra* updates
    if (t >= 0.0 && fixation_pra.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      fixation_pra.tStart = t;  // (not accounting for frame time here)
      fixation_pra.frameNStart = frameN;  // exact frame index
      
      fixation_pra.setAutoDraw(true);
    }
    
    frameRemains = 0.0 + 1.0 - psychoJS.window.monitorFramePeriod * 0.75;// most of one frame period left
    if (fixation_pra.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      fixation_pra.setAutoDraw(false);
    }
    
    
    // *stim1_pra* updates
    if (t >= 1.0 && stim1_pra.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      stim1_pra.tStart = t;  // (not accounting for frame time here)
      stim1_pra.frameNStart = frameN;  // exact frame index
      
      stim1_pra.setAutoDraw(true);
    }
    
    frameRemains = 1.0 + 1.0 - psychoJS.window.monitorFramePeriod * 0.75;// most of one frame period left
    if (stim1_pra.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      stim1_pra.setAutoDraw(false);
    }
    
    
    // *delay1_pra* updates
    if (t >= 2 && delay1_pra.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      delay1_pra.tStart = t;  // (not accounting for frame time here)
      delay1_pra.frameNStart = frameN;  // exact frame index
      
      delay1_pra.setAutoDraw(true);
    }
    
    frameRemains = 2 + 1.0 - psychoJS.window.monitorFramePeriod * 0.75;// most of one frame period left
    if (delay1_pra.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      delay1_pra.setAutoDraw(false);
    }
    
    
    // *stim2_pra* updates
    if (t >= 3 && stim2_pra.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      stim2_pra.tStart = t;  // (not accounting for frame time here)
      stim2_pra.frameNStart = frameN;  // exact frame index
      
      stim2_pra.setAutoDraw(true);
    }
    
    frameRemains = 3 + 1.0 - psychoJS.window.monitorFramePeriod * 0.75;// most of one frame period left
    if (stim2_pra.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      stim2_pra.setAutoDraw(false);
    }
    
    
    // *delay2_pra* updates
    if (t >= 4 && delay2_pra.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      delay2_pra.tStart = t;  // (not accounting for frame time here)
      delay2_pra.frameNStart = frameN;  // exact frame index
      
      delay2_pra.setAutoDraw(true);
    }
    
    frameRemains = 4 + 1.0 - psychoJS.window.monitorFramePeriod * 0.75;// most of one frame period left
    if (delay2_pra.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      delay2_pra.setAutoDraw(false);
    }
    
    
    // *probe_pra* updates
    if (t >= 5 && probe_pra.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      probe_pra.tStart = t;  // (not accounting for frame time here)
      probe_pra.frameNStart = frameN;  // exact frame index
      
      probe_pra.setAutoDraw(true);
    }
    
    
    // *option1_pra* updates
    if (t >= 5 && option1_pra.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      option1_pra.tStart = t;  // (not accounting for frame time here)
      option1_pra.frameNStart = frameN;  // exact frame index
      
      option1_pra.setAutoDraw(true);
    }
    
    
    // *option2_pra* updates
    if (t >= 5 && option2_pra.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      option2_pra.tStart = t;  // (not accounting for frame time here)
      option2_pra.frameNStart = frameN;  // exact frame index
      
      option2_pra.setAutoDraw(true);
    }
    
    
    // *option3_pra* updates
    if (t >= 5 && option3_pra.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      option3_pra.tStart = t;  // (not accounting for frame time here)
      option3_pra.frameNStart = frameN;  // exact frame index
      
      option3_pra.setAutoDraw(true);
    }
    
    
    // *key_resp1_pra* updates
    if (t >= 5 && key_resp1_pra.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      key_resp1_pra.tStart = t;  // (not accounting for frame time here)
      key_resp1_pra.frameNStart = frameN;  // exact frame index
      
      // keyboard checking is just starting
      psychoJS.window.callOnFlip(function() { key_resp1_pra.clock.reset(); });  // t=0 on next screen flip
      psychoJS.window.callOnFlip(function() { key_resp1_pra.start(); }); // start on screen flip
      psychoJS.window.callOnFlip(function() { key_resp1_pra.clearEvents(); });
    }
    
    if (key_resp1_pra.status === PsychoJS.Status.STARTED) {
      let theseKeys = key_resp1_pra.getKeys({keyList: ['g', 'h', 'j'], waitRelease: false});
      _key_resp1_pra_allKeys = _key_resp1_pra_allKeys.concat(theseKeys);
      if (_key_resp1_pra_allKeys.length > 0) {
        key_resp1_pra.keys = _key_resp1_pra_allKeys[_key_resp1_pra_allKeys.length - 1].name;  // just the last key pressed
        key_resp1_pra.rt = _key_resp1_pra_allKeys[_key_resp1_pra_allKeys.length - 1].rt;
        key_resp1_pra.duration = _key_resp1_pra_allKeys[_key_resp1_pra_allKeys.length - 1].duration;
        // a response ends the routine
        continueRoutine = false;
      }
    }
    
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    for (const thisComponent of PracticeComponents)
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
        break;
      }
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function PracticeRoutineEnd(snapshot) {
  return async function () {
    //--- Ending Routine 'Practice' ---
    for (const thisComponent of PracticeComponents) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    }
    psychoJS.experiment.addData('Practice.stopped', globalClock.getTime());
    key_resp1_pra.stop();
    // the Routine "Practice" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    // Routines running outside a loop should always advance the datafile row
    if (currentLoop === psychoJS.experiment) {
      psychoJS.experiment.nextEntry(snapshot);
    }
    return Scheduler.Event.NEXT;
  }
}


var StartMaxDurationReached;
var _startKey_allKeys;
var StartMaxDuration;
var StartComponents;
function StartRoutineBegin(snapshot) {
  return async function () {
    TrialHandler.fromSnapshot(snapshot); // ensure that .thisN vals are up to date
    
    //--- Prepare to start Routine 'Start' ---
    t = 0;
    frameN = -1;
    continueRoutine = true; // until we're told otherwise
    StartClock.reset();
    routineTimer.reset();
    StartMaxDurationReached = false;
    // update component parameters for each repeat
    startKey.keys = undefined;
    startKey.rt = undefined;
    _startKey_allKeys = [];
    psychoJS.experiment.addData('Start.started', globalClock.getTime());
    StartMaxDuration = null
    // keep track of which components have finished
    StartComponents = [];
    StartComponents.push(instruction_txt);
    StartComponents.push(startKey);
    StartComponents.push(keyG_3);
    StartComponents.push(keyH_3);
    StartComponents.push(keyJ_3);
    StartComponents.push(textboxG_3);
    StartComponents.push(textboxH_3);
    StartComponents.push(textboxJ_3);
    
    for (const thisComponent of StartComponents)
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
    return Scheduler.Event.NEXT;
  }
}


function StartRoutineEachFrame() {
  return async function () {
    //--- Loop for each frame of Routine 'Start' ---
    // get current time
    t = StartClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *instruction_txt* updates
    if (t >= 0.0 && instruction_txt.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      instruction_txt.tStart = t;  // (not accounting for frame time here)
      instruction_txt.frameNStart = frameN;  // exact frame index
      
      instruction_txt.setAutoDraw(true);
    }
    
    
    // *startKey* updates
    if (t >= 0.0 && startKey.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      startKey.tStart = t;  // (not accounting for frame time here)
      startKey.frameNStart = frameN;  // exact frame index
      
      // keyboard checking is just starting
      psychoJS.window.callOnFlip(function() { startKey.clock.reset(); });  // t=0 on next screen flip
      psychoJS.window.callOnFlip(function() { startKey.start(); }); // start on screen flip
      psychoJS.window.callOnFlip(function() { startKey.clearEvents(); });
    }
    
    if (startKey.status === PsychoJS.Status.STARTED) {
      let theseKeys = startKey.getKeys({keyList: ['space'], waitRelease: false});
      _startKey_allKeys = _startKey_allKeys.concat(theseKeys);
      if (_startKey_allKeys.length > 0) {
        startKey.keys = _startKey_allKeys[_startKey_allKeys.length - 1].name;  // just the last key pressed
        startKey.rt = _startKey_allKeys[_startKey_allKeys.length - 1].rt;
        startKey.duration = _startKey_allKeys[_startKey_allKeys.length - 1].duration;
        // a response ends the routine
        continueRoutine = false;
      }
    }
    
    
    // *keyG_3* updates
    if (t >= 0.0 && keyG_3.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      keyG_3.tStart = t;  // (not accounting for frame time here)
      keyG_3.frameNStart = frameN;  // exact frame index
      
      keyG_3.setAutoDraw(true);
    }
    
    
    // *keyH_3* updates
    if (t >= 0.0 && keyH_3.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      keyH_3.tStart = t;  // (not accounting for frame time here)
      keyH_3.frameNStart = frameN;  // exact frame index
      
      keyH_3.setAutoDraw(true);
    }
    
    
    // *keyJ_3* updates
    if (t >= 0.0 && keyJ_3.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      keyJ_3.tStart = t;  // (not accounting for frame time here)
      keyJ_3.frameNStart = frameN;  // exact frame index
      
      keyJ_3.setAutoDraw(true);
    }
    
    
    // *textboxG_3* updates
    if (t >= 0.0 && textboxG_3.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      textboxG_3.tStart = t;  // (not accounting for frame time here)
      textboxG_3.frameNStart = frameN;  // exact frame index
      
      textboxG_3.setAutoDraw(true);
    }
    
    
    // *textboxH_3* updates
    if (t >= 0.0 && textboxH_3.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      textboxH_3.tStart = t;  // (not accounting for frame time here)
      textboxH_3.frameNStart = frameN;  // exact frame index
      
      textboxH_3.setAutoDraw(true);
    }
    
    
    // *textboxJ_3* updates
    if (t >= 0.0 && textboxJ_3.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      textboxJ_3.tStart = t;  // (not accounting for frame time here)
      textboxJ_3.frameNStart = frameN;  // exact frame index
      
      textboxJ_3.setAutoDraw(true);
    }
    
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    for (const thisComponent of StartComponents)
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
        break;
      }
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function StartRoutineEnd(snapshot) {
  return async function () {
    //--- Ending Routine 'Start' ---
    for (const thisComponent of StartComponents) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    }
    psychoJS.experiment.addData('Start.stopped', globalClock.getTime());
    startKey.stop();
    // the Routine "Start" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    // Routines running outside a loop should always advance the datafile row
    if (currentLoop === psychoJS.experiment) {
      psychoJS.experiment.nextEntry(snapshot);
    }
    return Scheduler.Event.NEXT;
  }
}


var trialMaxDurationReached;
var _key_resp_allKeys;
var trialMaxDuration;
var trialComponents;
function trialRoutineBegin(snapshot) {
  return async function () {
    TrialHandler.fromSnapshot(snapshot); // ensure that .thisN vals are up to date
    
    //--- Prepare to start Routine 'trial' ---
    t = 0;
    frameN = -1;
    continueRoutine = true; // until we're told otherwise
    trialClock.reset();
    routineTimer.reset();
    trialMaxDurationReached = false;
    // update component parameters for each repeat
    // Run 'Begin Routine' code from trial_condition
    var _pj;
    function _pj_snippets(container) {
        function in_es6(left, right) {
            if (((right instanceof Array) || ((typeof right) === "string"))) {
                return (right.indexOf(left) > (- 1));
            } else {
                if (((right instanceof Map) || (right instanceof Set) || (right instanceof WeakMap) || (right instanceof WeakSet))) {
                    return right.has(left);
                } else {
                    return (left in right);
                }
            }
        }
        container["in_es6"] = in_es6;
        return container;
    }
    _pj = {};
    _pj_snippets(_pj);
    categories = {[1]: ["stimuli/Person/", "people"], [2]: ["stimuli/Animal/", "animals"], [3]: ["stimuli/Food/", "food items"], [4]: ["stimuli/Car/", "cars"]};
    positions = {[1]: "Earlier", [2]: "Later"};
    pic1 = `${categories[first_cat][0]}${first_pic_idx}.jpg`;
    pic2 = `${categories[second_cat][0]}${second_pic_idx}.jpg`;
    if (_pj.in_es6(probe_pic, positions)) {
        position_text = positions[probe_pic];
        if ((first_cat === second_cat)) {
            same_category = first_cat;
            different_category = same_category;
            if ((probe_validity === 1)) {
                category_text = categories[same_category][1];
            } else {
                different_category = (5 - same_category);
                category_text = categories[different_category][1];
            }
        } else {
            if ((probe_validity === 1)) {
                if ((probe_pic === 1)) {
                    category_text = categories[first_cat][1];
                } else {
                    category_text = categories[second_cat][1];
                }
            } else {
                if ((probe_pic === 1)) {
                    category_text = categories[second_cat][1];
                } else {
                    category_text = categories[first_cat][1];
                }
            }
        }
        probe_text = (((position_text + " picture, how many ") + category_text) + "?");
    } else {
        probe_text = "Invalid probe picture condition.";
    }
    psychoJS.experiment.addData("pic1", pic1);
    psychoJS.experiment.addData("pic2", pic2);
    psychoJS.experiment.addData("probe_cat", category_text);
    psychoJS.experiment.addData("probe_text", probe_text);
    
    stim1.setImage(pic1);
    stim2.setImage(pic2);
    probe.setText(probe_text);
    option1.setColor(new util.Color(option_texts[0]['color']));
    option1.setPos(option_texts[0]["pos"]);
    option1.setText(option_texts[0]["text"]);
    option2.setColor(new util.Color(option_texts[1]['color']));
    option2.setPos(option_texts[1]["pos"]);
    option2.setText(option_texts[1]["text"]);
    option3.setColor(new util.Color(option_texts[2]['color']));
    option3.setPos(option_texts[2]["pos"]);
    option3.setText(option_texts[2]["text"]);
    key_resp.keys = undefined;
    key_resp.rt = undefined;
    _key_resp_allKeys = [];
    psychoJS.experiment.addData('trial.started', globalClock.getTime());
    trialMaxDuration = null
    // keep track of which components have finished
    trialComponents = [];
    trialComponents.push(fixation);
    trialComponents.push(stim1);
    trialComponents.push(delay1);
    trialComponents.push(stim2);
    trialComponents.push(delay2);
    trialComponents.push(probe);
    trialComponents.push(option1);
    trialComponents.push(option2);
    trialComponents.push(option3);
    trialComponents.push(key_resp);
    
    for (const thisComponent of trialComponents)
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
    return Scheduler.Event.NEXT;
  }
}


function trialRoutineEachFrame() {
  return async function () {
    //--- Loop for each frame of Routine 'trial' ---
    // get current time
    t = trialClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *fixation* updates
    if (t >= 0.0 && fixation.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      fixation.tStart = t;  // (not accounting for frame time here)
      fixation.frameNStart = frameN;  // exact frame index
      
      fixation.setAutoDraw(true);
    }
    
    frameRemains = 0.0 + 1.0 - psychoJS.window.monitorFramePeriod * 0.75;// most of one frame period left
    if (fixation.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      fixation.setAutoDraw(false);
    }
    
    
    // *stim1* updates
    if (t >= 1.0 && stim1.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      stim1.tStart = t;  // (not accounting for frame time here)
      stim1.frameNStart = frameN;  // exact frame index
      
      stim1.setAutoDraw(true);
    }
    
    frameRemains = 1.0 + 1.0 - psychoJS.window.monitorFramePeriod * 0.75;// most of one frame period left
    if (stim1.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      stim1.setAutoDraw(false);
    }
    
    
    // *delay1* updates
    if (t >= 2 && delay1.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      delay1.tStart = t;  // (not accounting for frame time here)
      delay1.frameNStart = frameN;  // exact frame index
      
      delay1.setAutoDraw(true);
    }
    
    frameRemains = 2 + 1.0 - psychoJS.window.monitorFramePeriod * 0.75;// most of one frame period left
    if (delay1.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      delay1.setAutoDraw(false);
    }
    
    
    // *stim2* updates
    if (t >= 3 && stim2.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      stim2.tStart = t;  // (not accounting for frame time here)
      stim2.frameNStart = frameN;  // exact frame index
      
      stim2.setAutoDraw(true);
    }
    
    frameRemains = 3 + 1.0 - psychoJS.window.monitorFramePeriod * 0.75;// most of one frame period left
    if (stim2.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      stim2.setAutoDraw(false);
    }
    
    
    // *delay2* updates
    if (t >= 4 && delay2.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      delay2.tStart = t;  // (not accounting for frame time here)
      delay2.frameNStart = frameN;  // exact frame index
      
      delay2.setAutoDraw(true);
    }
    
    frameRemains = 4 + 2.5 - psychoJS.window.monitorFramePeriod * 0.75;// most of one frame period left
    if (delay2.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      delay2.setAutoDraw(false);
    }
    
    
    // *probe* updates
    if (t >= 6.5 && probe.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      probe.tStart = t;  // (not accounting for frame time here)
      probe.frameNStart = frameN;  // exact frame index
      
      probe.setAutoDraw(true);
    }
    
    
    // *option1* updates
    if (t >= 6.5 && option1.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      option1.tStart = t;  // (not accounting for frame time here)
      option1.frameNStart = frameN;  // exact frame index
      
      option1.setAutoDraw(true);
    }
    
    
    // *option2* updates
    if (t >= 6.5 && option2.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      option2.tStart = t;  // (not accounting for frame time here)
      option2.frameNStart = frameN;  // exact frame index
      
      option2.setAutoDraw(true);
    }
    
    
    // *option3* updates
    if (t >= 6.5 && option3.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      option3.tStart = t;  // (not accounting for frame time here)
      option3.frameNStart = frameN;  // exact frame index
      
      option3.setAutoDraw(true);
    }
    
    
    // *key_resp* updates
    if (t >= 6.5 && key_resp.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      key_resp.tStart = t;  // (not accounting for frame time here)
      key_resp.frameNStart = frameN;  // exact frame index
      
      // keyboard checking is just starting
      psychoJS.window.callOnFlip(function() { key_resp.clock.reset(); });  // t=0 on next screen flip
      psychoJS.window.callOnFlip(function() { key_resp.start(); }); // start on screen flip
      psychoJS.window.callOnFlip(function() { key_resp.clearEvents(); });
    }
    
    if (key_resp.status === PsychoJS.Status.STARTED) {
      let theseKeys = key_resp.getKeys({keyList: ['g', 'h', 'j'], waitRelease: false});
      _key_resp_allKeys = _key_resp_allKeys.concat(theseKeys);
      if (_key_resp_allKeys.length > 0) {
        key_resp.keys = _key_resp_allKeys[_key_resp_allKeys.length - 1].name;  // just the last key pressed
        key_resp.rt = _key_resp_allKeys[_key_resp_allKeys.length - 1].rt;
        key_resp.duration = _key_resp_allKeys[_key_resp_allKeys.length - 1].duration;
        // a response ends the routine
        continueRoutine = false;
      }
    }
    
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    for (const thisComponent of trialComponents)
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
        break;
      }
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function trialRoutineEnd(snapshot) {
  return async function () {
    //--- Ending Routine 'trial' ---
    for (const thisComponent of trialComponents) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    }
    psychoJS.experiment.addData('trial.stopped', globalClock.getTime());
    // update the trial handler
    if (currentLoop instanceof MultiStairHandler) {
      currentLoop.addResponse(key_resp.corr, level);
    }
    psychoJS.experiment.addData('key_resp.keys', key_resp.keys);
    if (typeof key_resp.keys !== 'undefined') {  // we had a response
        psychoJS.experiment.addData('key_resp.rt', key_resp.rt);
        psychoJS.experiment.addData('key_resp.duration', key_resp.duration);
        routineTimer.reset();
        }
    
    key_resp.stop();
    // the Routine "trial" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    // Routines running outside a loop should always advance the datafile row
    if (currentLoop === psychoJS.experiment) {
      psychoJS.experiment.nextEntry(snapshot);
    }
    return Scheduler.Event.NEXT;
  }
}


var break_textMaxDurationReached;
var _key_resp_break_allKeys;
var break_textMaxDuration;
var break_textComponents;
function break_textRoutineBegin(snapshot) {
  return async function () {
    TrialHandler.fromSnapshot(snapshot); // ensure that .thisN vals are up to date
    
    //--- Prepare to start Routine 'break_text' ---
    t = 0;
    frameN = -1;
    continueRoutine = true; // until we're told otherwise
    break_textClock.reset();
    routineTimer.reset();
    break_textMaxDurationReached = false;
    // update component parameters for each repeat
    // Run 'Begin Routine' code from code
    if ((((trials.thisN + 1) % 72) !== 0)) {
        continueRoutine = false;
    }
    
    text_break.setText(((util.round((trials.thisN / 288), 2) * 100).toString() + "% completed, press SPACE to continue"));
    key_resp_break.keys = undefined;
    key_resp_break.rt = undefined;
    _key_resp_break_allKeys = [];
    break_textMaxDuration = null
    // keep track of which components have finished
    break_textComponents = [];
    break_textComponents.push(text_break);
    break_textComponents.push(key_resp_break);
    break_textComponents.push(keyG_2);
    break_textComponents.push(keyH_2);
    break_textComponents.push(keyJ_2);
    break_textComponents.push(textboxG_2);
    break_textComponents.push(textboxH_2);
    break_textComponents.push(textboxJ_2);
    
    for (const thisComponent of break_textComponents)
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
    return Scheduler.Event.NEXT;
  }
}


function break_textRoutineEachFrame() {
  return async function () {
    //--- Loop for each frame of Routine 'break_text' ---
    // get current time
    t = break_textClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *text_break* updates
    if (t >= 0.0 && text_break.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      text_break.tStart = t;  // (not accounting for frame time here)
      text_break.frameNStart = frameN;  // exact frame index
      
      text_break.setAutoDraw(true);
    }
    
    
    // *key_resp_break* updates
    if (t >= 0.0 && key_resp_break.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      key_resp_break.tStart = t;  // (not accounting for frame time here)
      key_resp_break.frameNStart = frameN;  // exact frame index
      
      // keyboard checking is just starting
      psychoJS.window.callOnFlip(function() { key_resp_break.clock.reset(); });  // t=0 on next screen flip
      psychoJS.window.callOnFlip(function() { key_resp_break.start(); }); // start on screen flip
      psychoJS.window.callOnFlip(function() { key_resp_break.clearEvents(); });
    }
    
    if (key_resp_break.status === PsychoJS.Status.STARTED) {
      let theseKeys = key_resp_break.getKeys({keyList: ['space'], waitRelease: false});
      _key_resp_break_allKeys = _key_resp_break_allKeys.concat(theseKeys);
      if (_key_resp_break_allKeys.length > 0) {
        key_resp_break.keys = _key_resp_break_allKeys[_key_resp_break_allKeys.length - 1].name;  // just the last key pressed
        key_resp_break.rt = _key_resp_break_allKeys[_key_resp_break_allKeys.length - 1].rt;
        key_resp_break.duration = _key_resp_break_allKeys[_key_resp_break_allKeys.length - 1].duration;
        // a response ends the routine
        continueRoutine = false;
      }
    }
    
    
    // *keyG_2* updates
    if (t >= 0.0 && keyG_2.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      keyG_2.tStart = t;  // (not accounting for frame time here)
      keyG_2.frameNStart = frameN;  // exact frame index
      
      keyG_2.setAutoDraw(true);
    }
    
    
    // *keyH_2* updates
    if (t >= 0.0 && keyH_2.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      keyH_2.tStart = t;  // (not accounting for frame time here)
      keyH_2.frameNStart = frameN;  // exact frame index
      
      keyH_2.setAutoDraw(true);
    }
    
    
    // *keyJ_2* updates
    if (t >= 0.0 && keyJ_2.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      keyJ_2.tStart = t;  // (not accounting for frame time here)
      keyJ_2.frameNStart = frameN;  // exact frame index
      
      keyJ_2.setAutoDraw(true);
    }
    
    
    // *textboxG_2* updates
    if (t >= 0.0 && textboxG_2.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      textboxG_2.tStart = t;  // (not accounting for frame time here)
      textboxG_2.frameNStart = frameN;  // exact frame index
      
      textboxG_2.setAutoDraw(true);
    }
    
    
    // *textboxH_2* updates
    if (t >= 0.0 && textboxH_2.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      textboxH_2.tStart = t;  // (not accounting for frame time here)
      textboxH_2.frameNStart = frameN;  // exact frame index
      
      textboxH_2.setAutoDraw(true);
    }
    
    
    // *textboxJ_2* updates
    if (t >= 0.0 && textboxJ_2.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      textboxJ_2.tStart = t;  // (not accounting for frame time here)
      textboxJ_2.frameNStart = frameN;  // exact frame index
      
      textboxJ_2.setAutoDraw(true);
    }
    
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    for (const thisComponent of break_textComponents)
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
        break;
      }
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function break_textRoutineEnd(snapshot) {
  return async function () {
    //--- Ending Routine 'break_text' ---
    for (const thisComponent of break_textComponents) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    }
    key_resp_break.stop();
    // the Routine "break_text" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    // Routines running outside a loop should always advance the datafile row
    if (currentLoop === psychoJS.experiment) {
      psychoJS.experiment.nextEntry(snapshot);
    }
    return Scheduler.Event.NEXT;
  }
}


var thanksMaxDurationReached;
var thanksMaxDuration;
var thanksComponents;
function thanksRoutineBegin(snapshot) {
  return async function () {
    TrialHandler.fromSnapshot(snapshot); // ensure that .thisN vals are up to date
    
    //--- Prepare to start Routine 'thanks' ---
    t = 0;
    frameN = -1;
    continueRoutine = true; // until we're told otherwise
    thanksClock.reset();
    routineTimer.reset();
    thanksMaxDurationReached = false;
    // update component parameters for each repeat
    psychoJS.experiment.addData('thanks.started', globalClock.getTime());
    thanksMaxDuration = null
    // keep track of which components have finished
    thanksComponents = [];
    thanksComponents.push(endmsg);
    
    for (const thisComponent of thanksComponents)
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
    return Scheduler.Event.NEXT;
  }
}


function thanksRoutineEachFrame() {
  return async function () {
    //--- Loop for each frame of Routine 'thanks' ---
    // get current time
    t = thanksClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *endmsg* updates
    if (t >= 0.0 && endmsg.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      endmsg.tStart = t;  // (not accounting for frame time here)
      endmsg.frameNStart = frameN;  // exact frame index
      
      endmsg.setAutoDraw(true);
    }
    
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    for (const thisComponent of thanksComponents)
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
        break;
      }
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function thanksRoutineEnd(snapshot) {
  return async function () {
    //--- Ending Routine 'thanks' ---
    for (const thisComponent of thanksComponents) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    }
    psychoJS.experiment.addData('thanks.stopped', globalClock.getTime());
    // the Routine "thanks" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    // Routines running outside a loop should always advance the datafile row
    if (currentLoop === psychoJS.experiment) {
      psychoJS.experiment.nextEntry(snapshot);
    }
    return Scheduler.Event.NEXT;
  }
}


function importConditions(currentLoop) {
  return async function () {
    psychoJS.importAttributes(currentLoop.getCurrentTrial());
    return Scheduler.Event.NEXT;
    };
}


async function quitPsychoJS(message, isCompleted) {
  // Check for and save orphaned data
  if (psychoJS.experiment.isEntryEmpty()) {
    psychoJS.experiment.nextEntry();
  }
  psychoJS.window.close();
  psychoJS.quit({message: message, isCompleted: isCompleted});
  
  return Scheduler.Event.QUIT;
}
