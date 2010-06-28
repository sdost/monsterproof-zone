package com.bored.games.text 
{
	/**
	 * ...
	 * @author sam
	 */
	public class BitmapFontEngine
	{
		
		public function BitmapFontEngine() 
		{
			
		}
		
	}

}

/*
//BFE - Bitmap Font Engine
/***********************************************************************************************************************
													BFE FONT OBJECT
/***********************************************************************************************************************/
Object.prototype.bfeFont = function(fontName) {
	log("instantiating a BfeFont:"+fontName, 2);
	//contains meta-information about font(spacing, leading, kerning)
	this._space = 7;
	//size of the space in pixels
	this._leading = 0;
	//size of the space between lines; This is -2 to counteract the 2 pixel transparent border
	this._kerning = -2;
	//space between letters
	this._name = fontName;
	//remove path and suffix to get the clipName
	this.clipName = fontName.substring(0,fontName.length-4);
	var nameArray = this.clipName.split("/");
	this.clipName = nameArray.pop();
	//load the font swf and attach it to this clip   
	// all instances of bfeString will attach clips to this clip
	createEmptyMovieClip(this.clipName, font_i++);
	this._clip = eval(this.clipName);
	this._clip.loadMovie(fontName);
	return this;
};
bfeFont.prototype.isLoaded = function() {
	log("calling BfeFont.isLoaded", 4);
	//due to problems with the loaded movie saying it was loaded when it was not, the font files contain a 
	//stop action in the second frame with a _loaded var that is set to "true" (string) to aid in determining the loading state
	if (this._clip._loaded == "true") {
		return true;
	} else {
		return false;
	}
};
bfeFont.prototype.getSpace = function() {
	return this._space;
};
bfeFont.prototype.setSpace = function(newVal) {
	this._space = newVal;
};
bfeFont.prototype.getLeading = function() {
	return this._leading;
};
bfeFont.prototype.setLeading = function(newVal) {
	this._leading = newVal;
};
bfeFont.prototype.getKerning = function() {
	return this._kerning;
};
bfeFont.prototype.setKerning = function(newVal) {
	this._kerning = newVal;
};
bfeFont.prototype.getName = function() {
	return this._name;
};
bfeFont.prototype.getClip = function() {
	return this._clip;
};
/***********************************************************************************************************************
													BFE STRING OBJECT
/***********************************************************************************************************************/
Object.prototype.bfeString = function(text, font, x, y, width, height, duration) {
	log("instantiating a BfeString:"+text+", "+font.getName()+", "+x+", "+y+", "+width+", "+height, 2);
	/*
					text- the text of the movie clip
					x- x position
					y- y position
					font - a font object to attach a clip to 
					width - (optional)the maximum potential width before wrapping
					height- (optional)the maximum potential height before rendering's aborted
					*/
	this._ID = ++id;
	this._text = text;
	this._font = font;
	this._x = x;
	this._y = y;
	this._width = width;
	this._height = height;
	this.duration = duration;
	this.frame = 0;
	this._renderer = new Renderer(this);
	var fontClip = this._font.getClip();
	log("bfeFontClip:"+fontClip._target, 0);
	//increment the static index variable
	bfe_i++;
	//create a movieclip for the string in the root of the font's clip
	fontClip.createEmptyMovieClip("bfeString"+bfe_i, bfe_i);
	this._clip = eval("fontClip.bfeString"+bfe_i);
	log("bfeStringClip:"+this._clip._target, 0);
	return this;
};
bfeString.prototype.reDraw = function() {
	//invoked when a property changes, to redraw the screen
	log("calling reDraw", 0);
	this.clear();
	this.draw();
};
bfeString.prototype.getID = function() {
	return this._ID;
};
bfeString.prototype.getText = function() {
	return this._text;
};
bfeString.prototype.setText = function(setVal) {
	this._text = setVal;
	this.reDraw();
};
bfeString.prototype.getX = function() {
	return this._x;
};
bfeString.prototype.setX = function(setVal) {
	this._x = setVal;
	this._clip._x;
};
bfeString.prototype.getY = function() {
	return this._y;
};
bfeString.prototype.setY = function(setVal) {
	this._y = setVal;
	this._clip._y;
};
bfeString.prototype.getWidth = function() {
	return this._width;
};
bfeString.prototype.setWidth = function(setVal) {
	this._width = setVal;
	this.reDraw();
};
bfeString.prototype.getHeight = function() {
	return this._height;
};
bfeString.prototype.setHeight = function(setVal) {
	this._height = setVal;
	this.reDraw();
};
bfeString.prototype.getFont = function() {
	return this._font;
};
bfeString.prototype.getRenderer = function() {
	//don't see a purpose for this yet, but might as well
	return this._renderer;
};
bfeString.prototype.setRenderer = function(setVal) {
	//danger will robinson!
	this._renderer = setVal;
};
bfeString.prototype.setTransitionIn = function(transition) {
	//don't see a purpose for this yet, but might as well
	this._renderer.setTransitionIn(transition);
};
bfeString.prototype.setTransitionOut = function(transition) {
	//don't see a purpose for this yet, but might as well
	this._renderer.setTransitionOut(transition);
};
bfeString.prototype.transitionIn = function() {
	//don't see a purpose for this yet, but might as well
	this._renderer.transitionIn();
};
bfeString.prototype.transitionOut = function() {
	//don't see a purpose for this yet, but might as well
	this._renderer.transitionOut();
};
bfeString.prototype.draw = function() {
	//draw the type	
	log("calling BfeString.draw"+this.getText(), 4);
	this._renderer.draw(this);
};
bfeString.prototype.clear = function() {
	this._renderer.clear();
};
bfeString.prototype.getClip = function() {
	return this._clip;
};
bfeString.prototype.toString = function() {
	return "bfeString[text:"+this.getText()+"    font:"+this._font.getName()+"     x:"+this.getX()+"     y:"+this.getY()+"    Width:"+this.getWidth()+"   height:"+this.getHeight()+"]";
};
bfeString.prototype.unLoad = function() {
	log("Unloading bfeString", 2);
	this._clip.removeMovieClip();
	delete this;
};
/***********************************************************************************************************************
													RENDERER OBJECT
/***********************************************************************************************************************/
Object.prototype.Renderer = function(parent) {
	log("instantiating a Renderer", 2);
	//default factory for creating renderers for bfeString.
	this._parent = parent;
	this.duration = this._parent.duration;
	this.frame = 0;
	this._renderMethod = new StaticRender();
	this._transitionIn = new NullTransition();
	this._transitionOut = new NullTransition();
	this._isTransitionIn = false;
	//flags to determine the state of transition
	this._isTransitionOut = false;
};
Renderer.prototype.getTransitionIn = function(setVal) {
	return this._transitionIn;
};
Renderer.prototype.setTransitionIn = function(setVal) {
	this._isTransitionIn = true;
	this._transitionIn = setVal;
	this._transitionIn.init();
};
Renderer.prototype.getTransitionOut = function(setVal) {
	return this._transitionOut;
};
Renderer.prototype.setTransitionOut = function(setVal) {
	this._transitionOut = setVal;
	this._transitionOut.init();
};
Renderer.prototype.transitionIn = function() {
	this.clear();
	//clear for restart
	this._isTransitionOut = false;
	this._isTransitionIn = true;
	this._transitionIn.init(this._parent);
};
Renderer.prototype.transitionOut = function() {
	this._isTransitionIn = false;
	this._isTransitionOut = true;
	this._transitionOut.init(this._parent);
};
Renderer.prototype.draw = function(t) {
	log("calling Renderer.draw:"+t.getText(), 4);
	//draw the text statically. This doesn't draw continuously, it'll draw once, then return 0;
	this._renderMethod.draw(t);
	//transitionIn
	if (this._isTransitionIn == true) {
		var tmp = this._transitionIn.transitionIn(t, this._renderMethod);
		if (tmp == 1) {
			//transition is complete
			this._isTransitionIn = false;
		}
	} else if (this._isTransitionOut == true) {
		tmp = this._transitionOut.transitionOut(t, this._renderMethod);
		if (tmp == 1) {
			//transition is complete SELF-DESTRUCT IN 5.....   4.....   3....    2.... 1....
			log("self destructing...."+t.text, 0);
			removeInstance(t);
			this._isTransitionOut = false;
		}
	} else {
		log("no transitions duration:"+this.duration, 5);
		if (this.duration != null) {
			//the text is counting down
			this.frame++;
			if (this.frame == this.duration) {
				//initiate render
				log("timed out, transitioning out", 5);
				this.duration = null;
				//if we're transitioning in, then stop
				this._isTransitionIn = false;
				this.transitionOut();
			}
		}
	}
};
Renderer.prototype.clear = function() {
	log("calling Renderer.clear", 4);
	this._renderMethod.clear();
};
/***********************************************************************************************************************
													STATIC RENDER OBJECT
/***********************************************************************************************************************/
Object.prototype.StaticRender = function() {
	//StaticRender is the main rendering class. All other classes use the StaticRender class to manage 
	//basic functions such as word wrap and glyph drawing.
	log("instantiating a StaticRender", 2);
	this._count = 0;
	this._done = false;
};
StaticRender.prototype.draw = function(t) {
	if (this._done) {
		//all drawn, don't draw again!
		return 0;
	}
	log("calling StaticRender.draw", 4);
	log("got bfeString:"+t.toString(), 5);
	this._clip = t.getClip();
	//save clip for clear
	var glyph;
	var text = t.getText();
	var words = text.split(" ");
	var font = t.getFont();
	var reallyLongWord = false;
	var fontClip = font.getClip();
	log("draw.bfeStringClip:"+clip._target, 5);
	//move the clip to the correct position
	this._clip._x = t.getX();
	this._clip._y = t.getY();
	glyph_x = 0;
	glyph_y = 0;
	for (var i = 0; i<words.length; i++) {
		word = words[i];
		for (var j = 0; j<word.length; j++) {
			// 1. Determine word wrap
			if ((word.length*font.getSpace())+glyph_x+font.getKerning()>t.getWidth()) {
				//the word is too near the end to fit on the line. will it fit by itself?
				if ((word.length*font.getSpace())+font.getKerning()>t.getWidth()) {
					//it's a really big word, just render out characters until it finishes...
					reallyLongWord = true;
				} else {
					//make sure this is only called on the first letter of the word
					if (j == 0) {
						//create a newline
						glyph_x = 0;
						glyph_y += font.getLeading()+glyphClip._height;
					}
				}
			}
			//2. Display glyph
			glyph = dictionary.getGlyph(word.charAt(j));
			log("Glyph:"+glyph, 5);
			if (glyph == null || glyph == " ") {
				//unknown character, put in a space
				glyph_x += font.getSpace()+font.getKerning();
			} else if (glyph == "\n") {
				//control character, add newline
				glyph_x = 0;
				glyph_y += font.getLeading()+glyphClip._height;
			} else {
				//increment static counter for getCount
				this._count++;
				//standard character, display
				this._clip.attachMovie("c_"+glyph, "c_"+this._count, this._count);
				var glyphClip = eval("this._clip.c_"+this._count);
				log("glyphClip:"+"c_"+glyph, 5);
				//set the x,y position
				glyphClip._x = glyph_x;
				glyphClip._y = glyph_y;
				//move cursor over
				glyph_x += glyphClip._width+font.getKerning();
				//if this is a really long word, see if we need to wrap.
				//if it's not a really long word, then it should finish soon
				if (glyph_x>t.getWidth() && reallyLongWord) {
					//create a new column;
					glyph_x = 0;
					glyph_y += font.getLeading()+glyphClip._height;
				}
				//if the height gets too high, stop rendering!
				if (glyph_y>t.getHeight()) {
					this._done = true;
					log("TextOverflow:"+t.toString(), 2);
					break;
				}
			}
			//end else
		}
		//end for j
		//add space between words and clear reallyLongWord
		glyph_x += font.getSpace()+font.getKerning();
		reallyLongWord = false;
	}
	//end for i
	this._done = true;
	return 0;
};
StaticRender.prototype.clear = function() {
	//clears the clip
	var clip;
	for (i=0; i<this._count; i++) {
		clip = eval("this._clip.c_"+i);
		clip.removeMovieClip();
	}
	this._done = false;
	this._count = 0;
};
StaticRender.prototype.getCount = function() {
	return this._count;
};
/***********************************************************************************************************************
													TRANSITION OBJECT
/***********************************************************************************************************************/
//realised that it would be simpler and better to just put alpha,scale, and movement into one object this does what fadeTransition didn't
//additionally, you can use the same transition object for fadeing in and out
Object.prototype.Transition = function(originX, originY, xScale, yScale, alpha, duration, chars, frameSkip) {
	log("instantiating a Transition", 2);
	this.chars = (chars == null) ? 4 : chars;
	//number of characters to fade in at a time
	this.frameSkip = (frameSkip == null) ? 0 : frameSkip;
	this.duration = (duration == null) ? 5 : duration;
	this.originX = originX;
	this.originY = originY;
	this.alpha = (alpha == null) ? 100 : alpha;
	this.xScale = (xScale == null) ? 100 : xScale;
	this.yScale = (yScale == null) ? 100 : yScale;
	//you can skip frames to make it even slower...
	this.frameIndex = 0;
	this.index = 0;
	this.slided = false;
	//set easing equations for each (these can be changed to create many diffirent effects
	this.easeX = Math.easeInQuad;
	this.easeY = Math.easeOutQuad;
	this.easeAlpha = Math.linearTween;
	this.easexScale = Math.linearTween;
	this.easeyScale = Math.linearTween;
};
Transition.prototype.transitionIn = function(t, r) {
	return this.translate(t, r, "in");
};
Transition.prototype.transitionOut = function(t, r) {
	return this.translate(t, r, "out");
};
Transition.prototype.translate = function(t, r, type) {
	log("translate:"+t.getText(),5);
	// t is the bfeString r is the StaticRender
	var stringClip = t.getClip();
	log("Transitioning a Transition", 5);
	if (!this.slided) {
		if(type == "in"){
			for (var i = 1; i<=r.getCount(); i++) {
				clip = eval("stringClip.c_"+i);
				clip._visible = false;
			}
		}
		//if the origin is set to null, don't move the type around
		if(this.originX == null){
			log("null:"+stringClip._x,0);
			this.originX = stringClip._x;
		}
		if(this.originY == null){
			this.originY = stringClip._y;
		}
		
			
		this.clips = new Array();
		this.index = 1;
		this.slided = true;
	}
	//now draw the clip in
	//skip frames if needed
	if (this.frameIndex == this.frameSkip) {
		//reset frameCount
		this.frameIndex = 0;
			if (this.index<=r.getCount()) {
				//get a new clip
				this.clip = eval("stringClip.c_"+this.index);
				this.clips.push(new TranslateClip(this.clip, this.originX - stringClip._x, this.originY - stringClip._y, this.xScale, this.yScale, this.alpha, this.duration, this));
				this.index++;
			}
		var allDone;
		for (var i=0; i<this.clips.length; i++) {
			if (type == "in") {
				var done = this.clips[i].translateIn();
			} else {
				var done = this.clips[i].translateOut();
			}
			if (done) {
				allDone++;
			}
		}
	} else {
		this.frameIndex++;
	}
	if (allDone == r.getCount()) {
		return 1;
	}
};
TranslateClip = function (clip, originX, originY, xScale, yScale, alpha, duration, parent) {
	log("new TranslateClip: destX:"+originX+"   desty:"+originY, 4);
	this.clip = clip;
	this.clip._visible = true;
	this.destX = this.clip._x;
	this.destY = this.clip._y;
	this.clip._x += originX;
	this.clip._y += originY;
	this.originX = this.clip._x;
	this.originY = this.clip._y;
	this.parent = parent;
	// move x
	if (destx != this.originX) {
		this.hasX = true;
	}
	// move y
	if (desty != this.originY) {
		this.hasY = true;
	}
	// xScale
	if (xScale != 100) {
		this.xScale = xScale;
		this.hasXScale = true;
	} else {
		this.hasXScale = false;
	}
	// yScale
	if (yScale != 100) {
		this.yScale = yScale;
		this.hasYScale = true;
	} else {
		this.hasYScale = false;
	}
	// alpha
	if (this.alpha<100) {
		this.alpha = alpha;
		this.hasAlpha = true;
	} else {
		this.hasAlpha = false;
	}
	this.index = 1;
	this.duration = duration;
	this.done = false;
};
TranslateClip.prototype.translateIn = function() {
	if (this.index>this.duration) {
		return true;
	}
	if (this.hasX) {
		this.clip._x = this.parent.easeX(this.index, this.originX, this.destX-this.originX, this.duration);
	}
	if (this.hasY) {
		this.clip._y = this.parent.easeY(this.index, this.originY, this.destY-this.originY, this.duration);
	}
	if (this.hasXScale) {
		this.clip._xscale = this.parent.easeXScale(this.index, this.xScale, 100-this.xScale, this.duration);
	}
	if (this.hasXScale) {
		this.clip._yscale = this.parent.easeYScale(this.index, this.yScale, 100-this.yScale, this.duration);
	}
	if (this.hasAlpha) {
		this.clip._alpha = this.parent.easeAlpha(this.index, this.alpha, 100-this.alpha, this.duration);
	}
	this.index++;
	return false;
};
TranslateClip.prototype.translateOut = function() {
	if (this.index>this.duration) {
		return true;
	}
	if (this.hasX) {
		this.clip._x = this.parent.easeX(this.index, this.destX, this.originX-this.destX, this.duration);
	}
	if (this.hasY) {
		this.clip._y = this.parent.easeY(this.index, this.destY, this.originY-this.destY, this.duration);
	}
	if (this.hasXScale) {
		this.clip._xscale = this.parent.easeXScale(this.index, 100, this.xScale - 100 , this.duration);
	}
	if (this.hasXScale) {
		this.clip._yscale = this.parent.easeYScale(this.index, 100, this.yScale - 100, this.duration);
	}
	if (this.hasAlpha) {
		this.clip._alpha = this.parent.easeAlpha(this.index, 100, this.alpha - 100, this.duration);
	}
	this.index++;
	return false;
};
Transition.prototype.initTranistionIn = function() {
	this.init();
};
Transition.prototype.initTranistionOut = function() {
	this.init();
};
Transition.prototype.init = function(t) {
	//stub
	this.slided = false;
	this.frameIndex = 0;
};

/*-------------------------------------------------------------------------
					NULL TRANSITION OBJECT
					------------------------------------------------------------------*/
Object.prototype.NullTransition = function() {;
	//null transition object
};
NullTransition.prototype.transitionOut = function() {
	return 1;
};
NullTransition.prototype.transitionIn = function() {
	return 1;
};

*/