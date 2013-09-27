// Generated by CoffeeScript 1.6.3
(function() {
  var AppData, Art, Collision, Entity, Game, Hero, Keyboard, Level1, SpriteImage, World, arrayEgal, bold, currentFile, egal, failures, func, green, log, name, passedTests, red, reset, startTime, testmessage, _ref, _ref1, _ref2,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __slice = [].slice;

  Array.prototype.remove = function(e) {
    var t, _ref;
    if ((t = this.indexOf(e)) > -1) {
      return ([].splice.apply(this, [t, t - t + 1].concat(_ref = [])), _ref);
    }
  };

  Array.prototype.diff = function(a) {
    return this.filter(function(i) {
      return !(a.indexOf(i) > -1);
    });
  };

  Array.prototype.copy = function() {
    return this.slice(0);
  };

  Math.sign = function(n) {
    return (n > 0 ? 1 : (n < 0 ? -1 : 0));
  };

  Array.prototype.unique = function() {
    return this.sort().filter(function(v, i, o) {
      if (i && v !== o[i - 1]) {
        return v;
      } else {
        return 0;
      }
    });
  };

  Array.prototype.deepToString = function() {
    var i, result, _i, _ref;
    result = "[";
    for (i = _i = 0, _ref = this.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      if (Object.prototype.toString.call(this[i]) === "[object Array]") {
        result += this[i].deepToString();
      } else if (this[i]) {
        result += this[i];
      }
      if (i !== this.length - 1) {
        result += ",";
      }
    }
    return result + "]";
  };

  Entity = (function() {
    function Entity() {}

    Entity.prototype.x = 0;

    Entity.prototype.y = 0;

    Entity.prototype.sx = 0;

    Entity.prototype.sy = 0;

    Entity.prototype.w = void 0;

    Entity.prototype.h = void 0;

    Entity.prototype.visible = true;

    Entity.prototype.name = null;

    Entity.prototype.types = [];

    Entity.prototype.scale_x = 1;

    Entity.prototype.scale_y = 1;

    Entity.prototype.offset_x = 0;

    Entity.prototype.offset_y = 0;

    Entity.prototype.alpha = 1;

    Entity.prototype.rotation = 0;

    Entity.prototype.index = 1;

    Entity.prototype.sprite = null;

    Entity.prototype.z = 0;

    Entity.prototype.draw = function() {
      return Art.entity(this);
    };

    Entity.prototype.init = function() {
      return null;
    };

    Entity.prototype.step = function() {
      return null;
    };

    Entity.prototype.hits = function(other, x, y) {
      var result;
      if (x == null) {
        x = 0;
      }
      if (y == null) {
        y = 0;
      }
      result = Collision.check(this, other, x, y);
      return result[1];
    };

    Entity.prototype.destroy = function() {
      return World.destroy(this);
    };

    Entity.prototype.reset = function() {
      this.x = this.sx;
      return this.y = this.sy;
    };

    Entity.prototype.mouse_hits = function() {
      return Keyboard.MOUSE_X > this.x && Keyboard.MOUSE_X < this.x + this.w && Keyboard.MOUSE_Y > this.y && Keyboard.MOUSE_Y < this.y + this.h;
    };

    return Entity;

  })();

  Art = (function() {
    function Art() {}

    Art.images = {};

    Art.offset_x = 0;

    Art.offset_y = 0;

    Art._font = 'Dosis';

    Art._font_size = 16;

    Art._font_style = "";

    Art._scale = 1;

    Art._alpha = 1;

    Art._images_loaded = 0;

    Art.callback = null;

    Art.init = function(canvas, callback) {
      var key, value, _ref;
      Art.callback = callback;
      Art.canvas = canvas;
      Art.canvas.textBaseline = 'top';
      Art.font_update();
      _ref = AppData.sprites;
      for (key in _ref) {
        value = _ref[key];
        Art.load(key, "sprites/" + value);
      }
      Art.remove_anti_alias();
      return Art.scale(AppData.scale);
    };

    Art.image_loaded = function() {
      var number_of_images;
      Art._images_loaded += 1;
      number_of_images = Object.keys(AppData.sprites).length;
      if (Art._images_loaded === number_of_images) {
        return Art.callback();
      }
    };

    Art.remove_anti_alias = function() {
      Art.canvas.imageSmoothingEnabled = false;
      Art.canvas.mozImageSmoothingEnabled = false;
      return Art.canvas.webkitImageSmoothingEnabled = false;
    };

    Art.get_scale = function() {
      return this._scale;
    };

    Art.scale = function(rate) {
      Art.canvas.scale(rate / Art._scale, rate / Art._scale);
      return Art._scale = rate;
    };

    Art.load = function(name, file) {
      return Art.images[name] = new SpriteImage(file);
    };

    Art.image_exists = function(name) {
      return Art.images[name] !== null;
    };

    Art._image = function(name, index) {
      var result;
      if (index == null) {
        index = 1;
      }
      if (index !== 1) {
        name = name + index;
      }
      result = Art.images[name];
      if (!result) {
        console.log(name);
        result = Art.images['PlaceHolder'];
      }
      return result;
    };

    Art.entity = function(e) {
      return Art.entityC(e, Art.offset_x, Art.offset_y);
    };

    Art.entityC = function(e, offset_x, offset_y) {
      var i, x, y;
      if (offset_x == null) {
        offset_x = 0;
      }
      if (offset_y == null) {
        offset_y = 0;
      }
      x = e.x + offset_x - e.offset_x;
      y = e.y + offset_y - e.offset_y;
      i = Art._image(e.sprite, e.index);
      if (e.rotation === 0 && e.scale_x === 1 && e.scale_y === 1) {
        return Art.canvas.drawImage(i.image, 0, 0, i.w, i.h, x, y, i.w, i.h);
      } else {
        Art.canvas.save();
        Art.canvas.translate(x + i.w / 2, y + i.h / 2);
        Art.canvas.scale(e.scale_x, e.scale_y);
        Art.canvas.rotate(Math.PI / 180 * e.rotation);
        Art.canvas.drawImage(i.image, 0, 0, i.w, i.h, -i.w / 2, -i.h / 2, i.w, i.h);
        return Art.canvas.restore();
      }
    };

    Art.sprite_width = function(name) {
      return Art._image(name).w;
    };

    Art.sprite_height = function(name) {
      return Art._image(name).h;
    };

    Art.line = function(x, y, x2, y2) {
      return Art.lineC(x + Art.offset_x, y + Art.offset_y, x2 + Art.offset_x, y2 + Art.offset_y);
    };

    Art.get_alpha = function() {
      return Art._alpha;
    };

    Art.alpha = function(alpha) {
      Art._alpha = alpha;
      return Art.canvas.globalAlpha = alpha;
    };

    Art.lineC = function(x, y, x2, y2) {
      Art.canvas.beginPath();
      Art.canvas.moveTo(x + 0.5, y + 0.5);
      Art.canvas.lineTo(x2 + 0.5, y2 + 0.5);
      return Art.canvas.stroke();
    };

    Art.color = function(color) {
      Art.canvas.fillStyle = color;
      return Art.canvas.strokeStyle = color;
    };

    Art.fill_color = function(color) {
      return Art.canvas.fillStyle = color;
    };

    Art.stroke_color = function(color) {
      return Art.canvas.strokeStyle = color;
    };

    Art.font = function(font) {
      Art._font = font;
      return Art.font_update();
    };

    Art.font_size = function(font_size) {
      Art._font_size = font_size;
      return Art.font_update();
    };

    Art.font_style = function(font_style) {
      Art._font_style = font_style;
      return Art.font_update();
    };

    Art.font_update = function() {
      return Art.canvas.font = Art._font_style + " " + Art._font_size + " " + Art._font;
    };

    Art.text = function(string, x, y, rotation) {
      if (rotation == null) {
        rotation = 0;
      }
      return Art.textC(string, x + Art.offset_x, y + Art.offset_y, rotation);
    };

    Art.textC = function(string, x, y, rotation) {
      if (rotation == null) {
        rotation = 0;
      }
      if (rotation !== 0) {
        Art.canvas.save();
        Art.canvas.translate(x + Art.text_width(string) / 2, y + Art.font_size / 2);
        Art.canvas.rotate(Math.PI / 180 * rotation);
        Art.canvas.fillText(string, -Art.text_width(string) / 2, -Art.font_size / 2);
        return Art.canvas.restore();
      } else {
        return Art.canvas.fillText(string, x, y);
      }
    };

    Art.text_width = function(string) {
      Art.font_update();
      return Art.canvas.measureText(string).width;
    };

    Art.text_height = function(string) {
      Art.font_update();
      return this._font_size;
    };

    Art.rectangleC = function(x, y, w, h, filled) {
      if (filled == null) {
        filled = false;
      }
      if (filled === true) {
        return Art.canvas.fillRect(x, y, w, h);
      } else {
        return Art.canvas.strokeRect(x, y, w, h);
      }
    };

    Art.rectangle = function(x, y, w, h, filled) {
      if (filled == null) {
        filled = false;
      }
      return Art.rectangleC(x + Art.offset_x, y + Art.offset_y, w, h, filled);
    };

    return Art;

  })();

  Collision = (function(_super) {
    __extends(Collision, _super);

    function Collision() {
      _ref = Collision.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Collision.check = function(type1, type2, x, y) {
      var e, o1, o2, objects1, objects2, _i, _j, _k, _len, _len1, _len2, _ref1;
      objects1 = [];
      objects2 = [];
      if (typeof type1 === 'object') {
        objects1.push(type1);
      }
      if (typeof type2 === 'object') {
        objects2.push(type2);
      }
      _ref1 = World.all_entities();
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        e = _ref1[_i];
        if (e.name === type1 || e.types.indexOf(type1) !== -1) {
          objects1.push(e);
        }
        if (e.name === type2 || e.types.indexOf(type2) !== -1) {
          objects2.push(e);
        }
      }
      for (_j = 0, _len1 = objects1.length; _j < _len1; _j++) {
        o1 = objects1[_j];
        for (_k = 0, _len2 = objects2.length; _k < _len2; _k++) {
          o2 = objects2[_k];
          if (((o1.x + x <= o2.x && o1.x + x + o1.w > o2.x) || (o1.x + x >= o2.x && o1.x + x < o2.x + o2.w)) && ((o1.y + y <= o2.y && o1.y + y + o1.h > o2.y) || (o1.y + y >= o2.y && o1.y + y < o2.y + o2.h))) {
            return [o1, o2];
          }
        }
      }
      return false;
    };

    return Collision;

  })(Entity);

  Game = (function() {
    function Game() {
      this.main = __bind(this.main, this);
      this.run = __bind(this.run, this);
    }

    Game.prototype.run = function() {
      World.init();
      return setInterval(this.main, 16);
    };

    Game.prototype.main = function() {
      World.step();
      return World.draw();
    };

    return Game;

  })();

  Keyboard = (function() {
    function Keyboard() {}

    Keyboard._keyCodes = {
      'BACKSPACE': 8,
      'TAB': 9,
      'ENTER': 13,
      'SHIFT': 16,
      'CTRL': 17,
      'ALT': 18,
      'CAPSLOCK': 20,
      'ESCAPE': 27,
      'SPACE': 32,
      'END': 35,
      'HOME': 36,
      'LEFT': 37,
      'UP': 38,
      'RIGHT': 39,
      'DOWN': 40,
      'INSERT': 45,
      'DELETE': 46,
      '0': 48,
      '1': 49,
      '2': 50,
      '3': 51,
      '4': 52,
      '5': 53,
      '6': 54,
      '7': 55,
      '8': 56,
      '9': 57,
      'A': 65,
      'B': 66,
      'C': 67,
      'D': 68,
      'E': 69,
      'F': 70,
      'G': 71,
      'H': 72,
      'I': 73,
      'J': 74,
      'K': 75,
      'L': 76,
      'M': 77,
      'N': 78,
      'O': 79,
      'P': 80,
      'Q': 81,
      'R': 82,
      'S': 83,
      'T': 84,
      'U': 85,
      'V': 86,
      'W': 87,
      'X': 88,
      'Y': 89,
      'Z': 90,
      'MULTIPLY': 106,
      'ADD': 107,
      'SUBTRACT': 109,
      'MOUSE_LEFT': 'MOUSE_LEFT',
      'MOUSE_MIDDLE': 'MOUSE_MIDDLE',
      'MOUSE_RIGHT': 'MOUSE_RIGHT'
    };

    Keyboard._pre_pressed = [];

    Keyboard._pre_released = [];

    Keyboard._pressed = [];

    Keyboard._released = [];

    Keyboard._hold = [];

    Keyboard.init = function() {
      var _this = this;
      $("body").keydown(function(e) {
        return Keyboard.key_pressed(e.keyCode);
      });
      $("body").keyup(function(e) {
        return Keyboard.key_released(e.keyCode);
      });
      $("#game").mousemove(Keyboard.mouse_move);
      $("#game").mousedown(Keyboard.mouse_down);
      $("#game").mouseup(Keyboard.mouse_up);
      return $("#game").bind("contextmenu", function(e) {
        return false;
      });
    };

    Keyboard.key_released = function(c) {
      return Keyboard._pre_released.push(c);
    };

    Keyboard.key_pressed = function(c) {
      return Keyboard._pre_pressed.push(c);
    };

    Keyboard.mouse_down = function(e) {
      switch (e.button) {
        case 0:
          Keyboard._pre_pressed.push('MOUSE_LEFT');
          break;
        case 1:
          Keyboard._pre_pressed.push('MOUSE_MIDDLE');
          break;
        case 2:
          Keyboard._pre_pressed.push('MOUSE_RIGHT');
      }
      return false;
    };

    Keyboard.mouse_up = function(e) {
      switch (e.button) {
        case 0:
          Keyboard._pre_released.push('MOUSE_LEFT');
          break;
        case 1:
          Keyboard._pre_released.push('MOUSE_MIDDLE');
          break;
        case 2:
          Keyboard._pre_released.push('MOUSE_RIGHT');
      }
      return false;
    };

    Keyboard.mouse_move = function(e) {
      Keyboard.MOUSE_XC = e.offsetX / Art.get_scale();
      Keyboard.MOUSE_YC = e.offsetY / Art.get_scale();
      Keyboard.MOUSE_X = Keyboard.MOUSE_XC - Art.offset_x;
      return Keyboard.MOUSE_Y = Keyboard.MOUSE_YC - Art.offset_y;
    };

    Keyboard.hold = function(keyName) {
      return Keyboard._hold.indexOf(Keyboard._keyCodes[keyName]) !== -1;
    };

    Keyboard.press = function(keyName) {
      return Keyboard._pressed.indexOf(Keyboard._keyCodes[keyName]) !== -1;
    };

    Keyboard.release = function(keyName) {
      return Keyboard._released.indexOf(Keyboard._keyCodes[keyName]) !== -1;
    };

    Keyboard.step = function() {
      Keyboard._pressed = Keyboard._pre_pressed.splice(0);
      Keyboard._released = Keyboard._pre_released.splice(0);
      Keyboard._hold = Keyboard._hold.concat(Keyboard._pressed);
      Keyboard._hold = Keyboard._hold.diff(Keyboard._released);
      Keyboard._pre_pressed = [];
      return Keyboard._pre_released = [];
    };

    return Keyboard;

  })();

  World = (function() {
    function World() {}

    World._entities = [];

    World._entities_to_destroy = [];

    World.frozen = false;

    World.init = function() {
      var ctx;
      ctx = World.create_canvas();
      return Art.init(ctx, World.art_loaded);
    };

    World.art_loaded = function() {
      World.create_level();
      return Keyboard.init();
    };

    World.create_level = function() {
      var key, value, _ref1, _results;
      _ref1 = Level1.level;
      _results = [];
      for (key in _ref1) {
        value = _ref1[key];
        _results.push(World.spawn(value.name, value.x, value.y));
      }
      return _results;
    };

    World.destroy_all = function() {
      var e, temp, _i, _len, _results;
      temp = World._entities.slice(0);
      _results = [];
      for (_i = 0, _len = temp.length; _i < _len; _i++) {
        e = temp[_i];
        _results.push(World._entities.remove(e));
      }
      return _results;
    };

    World.reset = function() {
      this.destroy_all();
      return this.create_level();
    };

    World.next_level = function() {
      this.destory_all();
      return this.create_level();
    };

    World.all_entities = function() {
      return this._entities;
    };

    World.destroy = function(entity) {
      return World._entities_to_destroy.push(entity);
    };

    World._remove_destroyed = function() {
      var e, _i, _len, _ref1;
      _ref1 = World._entities_to_destroy;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        e = _ref1[_i];
        World._entities.remove(e);
      }
      return World._entities_to_destroy = [];
    };

    World.spawn = function(name, x, y) {
      var entity;
      if (x == null) {
        x = 0;
      }
      if (y == null) {
        y = 0;
      }
      entity = new AppData.entities[name];
      if (entity.name === null) {
        entity.name = name;
      }
      if (entity.sprite === null) {
        if (Art.image_exists(name)) {
          entity.sprite = name;
        } else {
          entity.sprite = 'PlaceHolder';
        }
      }
      entity.sx = x;
      entity.sy = y;
      if (entity.w === void 0 && entity.sprite !== null) {
        entity.w = Art.sprite_width(entity.sprite);
      }
      if (entity.h === void 0 && entity.sprite !== null) {
        entity.h = Art.sprite_height(entity.sprite);
      }
      World._entities.push(entity);
      entity.reset();
      entity.init();
      return entity;
    };

    World.number_of = function(c) {
      return World.objectsOfClass(c).length;
    };

    World.exists = function(c) {
      return World.number_of(c > 0);
    };

    World.create_canvas = function() {
      var canvas;
      canvas = document.createElement("canvas");
      canvas.width = AppData.width * AppData.scale;
      canvas.height = AppData.height * AppData.scale;
      $("#game").append(canvas);
      return canvas.getContext("2d");
    };

    World.draw = function() {
      var entity, _i, _len, _ref1, _results;
      Art.color('#EFF8FB');
      Art.rectangleC(0, 0, AppData.width * AppData.scale / Art.get_scale(), AppData.height * AppData.scale / Art.get_scale(), true);
      Art.color('#000000');
      World._entities.sort(function(a, b) {
        if (a.z > b.z) {
          return 1;
        } else {
          return -1;
        }
      });
      _ref1 = World._entities;
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        entity = _ref1[_i];
        if (!(entity.visible === true)) {
          continue;
        }
        if (Art.get_alpha() !== 1) {
          Art.alpha(1);
        }
        _results.push(entity.draw());
      }
      return _results;
    };

    World.step = function() {
      var entity, _i, _len, _ref1;
      Keyboard.step();
      if (World.frozen === false) {
        _ref1 = World._entities;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          entity = _ref1[_i];
          if (typeof entity.step === "function") {
            entity.step();
          }
        }
      }
      return World._remove_destroyed();
    };

    return World;

  })();

  Hero = (function(_super) {
    __extends(Hero, _super);

    function Hero() {
      _ref1 = Hero.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    Hero.prototype.direction = 0;

    Hero.prototype.move = 'WALKING';

    Hero.prototype.animation = 0;

    Hero.prototype.step = function() {
      var face_x, face_y;
      face_x = 0;
      face_y = 0;
      if (Keyboard.hold('RIGHT')) {
        face_x += 1;
      }
      if (Keyboard.hold('LEFT')) {
        face_x -= 1;
      }
      if (Keyboard.hold('UP')) {
        face_y -= 1;
      }
      if (Keyboard.hold('DOWN')) {
        face_y += 1;
      }
      this.move = 'WALKING';
      if (face_x === -1) {
        if (face_y === -1) {
          this.direction = 90 + 45;
        }
        if (face_y === 0) {
          this.direction = 180;
        }
        if (face_y === 1) {
          this.direction = 180 + 45;
        }
      }
      if (face_x === 0) {
        if (face_y === -1) {
          this.direction = 90;
        }
        if (face_y === 0) {
          this.move = 'STANDING';
        }
        if (face_y === 1) {
          this.direction = 270;
        }
      }
      if (face_x === 1) {
        if (face_y === -1) {
          this.direction = 45;
        }
        if (face_y === 0) {
          this.direction = 0;
        }
        if (face_y === 1) {
          this.direction = 270 + 45;
        }
      }
      this.scale_x = 1;
      if (this.direction === 0) {
        this.index = 5;
      }
      if (this.direction === 45) {
        this.index = 7;
      }
      if (this.direction === 90) {
        this.index = 9;
      }
      if (this.direction === 90 + 45) {
        this.index = 7;
        this.scale_x = -1;
      }
      if (this.direction === 180) {
        this.index = 5;
        this.scale_x = -1;
      }
      if (this.direction === 180 + 45) {
        this.index = 3;
        this.scale_x = -1;
      }
      if (this.direction === 270) {
        this.index = 1;
      }
      if (this.direction === 270 + 45) {
        this.index = 3;
      }
      if (this.animation > 20) {
        this.animation = 0;
      }
      if (this.animation > 10) {
        this.index += 1;
      }
      if (this.move === 'WALKING') {
        this.animation += 1;
        this.x += Math.cos(this.direction / 180 * Math.PI);
        return this.y -= Math.sin(this.direction / 180 * Math.PI);
      }
    };

    Hero.prototype.draw = function() {
      Hero.__super__.draw.apply(this, arguments);
      Art.font('Gochi Hand');
      Art.text('123', 0, 0);
      Art.font('Dosis');
      Art.text('Espresso running..', 0, 100);
      Art.font('Londrina Outline');
      return Art.text('Espresso running..', 0, 160);
    };

    return Hero;

  })(Entity);

  Level1 = (function() {
    function Level1() {}

    Level1.level = {
      1: {
        name: 'Hero',
        x: 238,
        y: 103
      }
    };

    return Level1;

  })();

  AppData = (function() {
    function AppData() {}

    AppData.game_name = "template";

    AppData.width = 320;

    AppData.height = 240;

    AppData.scale = 2;

    AppData.entities = {
      'Hero': Hero
    };

    AppData.sprites = {
      'Hero': 'Hero.png',
      'Hero10': 'Hero10.png',
      'Hero2': 'Hero2.png',
      'Hero3': 'Hero3.png',
      'Hero4': 'Hero4.png',
      'Hero5': 'Hero5.png',
      'Hero6': 'Hero6.png',
      'Hero7': 'Hero7.png',
      'Hero8': 'Hero8.png',
      'Hero9': 'Hero9.png',
      'PlaceHolder': 'PlaceHolder.png'
    };

    return AppData;

  })();

  SpriteImage = (function() {
    function SpriteImage(url) {
      var image,
        _this = this;
      image = new Image;
      image.src = url;
      image.onload = function() {
        return _this.loaded();
      };
      this.image = image;
    }

    SpriteImage.prototype.loaded = function() {
      Art.image_loaded();
      this.h = this.image.height;
      return this.w = this.image.width;
    };

    return SpriteImage;

  })();

  bold = '\x1B[0;1m';

  red = '\x1B[0;31m';

  green = '\x1B[0;32m';

  reset = '\x1B[0m';

  log = function(message, color, explanation) {
    return console.log(color + message + reset + ' ' + (explanation || ''));
  };

  startTime = Date.now();

  currentFile = null;

  passedTests = 0;

  failures = [];

  _ref2 = require('assert');
  for (name in _ref2) {
    func = _ref2[name];
    global[name] = func;
  }

  global.test = function(description, fn) {
    var e;
    try {
      fn.test = {
        description: description,
        currentFile: currentFile
      };
      fn.call(fn);
      return ++passedTests;
    } catch (_error) {
      e = _error;
      return failures.push({
        filename: currentFile,
        error: e,
        description: description != null ? description : void 0,
        source: fn.toString != null ? fn.toString() : void 0
      });
    }
  };

  egal = function(a, b) {
    if (a === b) {
      return a !== 0 || 1 / a === 1 / b;
    } else {
      return a !== a && b !== b;
    }
  };

  arrayEgal = function(a, b) {
    var el, idx, _i, _len;
    if (egal(a, b)) {
      return true;
    } else if (a instanceof Array && b instanceof Array) {
      if (a.length !== b.length) {
        return false;
      }
      for (idx = _i = 0, _len = a.length; _i < _len; idx = ++_i) {
        el = a[idx];
        if (!arrayEgal(el, b[idx])) {
          return false;
        }
      }
      return true;
    }
  };

  global.eq = function(a, b, msg) {
    return ok(egal(a, b), msg != null ? msg : "Expected " + a + " to equal " + b);
  };

  global.arrayEq = function(a, b, msg) {
    return ok(arrayEgal(a, b), msg != null ? msg : "Expected " + a + " to deep equal " + b);
  };

  testmessage = function() {
    var description, error, fail, filename, message, source, time, _i, _len, _results;
    time = ((Date.now() - startTime) / 1000).toFixed(2);
    message = "passed " + passedTests + " tests in " + time + " seconds" + reset;
    if (!failures.length) {
      return log(message, green);
    }
    log("failed " + failures.length + " and " + message, red);
    _results = [];
    for (_i = 0, _len = failures.length; _i < _len; _i++) {
      fail = failures[_i];
      error = fail.error, filename = fail.filename, description = fail.description, source = fail.source;
      if (description) {
        log("  " + description, red);
      }
      log("  " + error.stack, red);
      if (source) {
        _results.push(console.log("  " + source));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  testmessage();

  test("array splat expansions with assignments", function() {
    var a, b, list, nums;
    nums = [1, 2, 3];
    list = [a = 0].concat(__slice.call(nums), [b = 4]);
    eq(0, a);
    eq(4, b);
    return arrayEq([0, 1, 2, 3, 4], list);
  });

}).call(this);
