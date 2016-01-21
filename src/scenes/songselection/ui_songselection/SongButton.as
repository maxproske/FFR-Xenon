package scenes.songselection.ui_songselection
{
	import classes.engine.EngineCore;
	import classes.engine.EngineLevel;
	import classes.ui.Label;
	import classes.ui.UIComponent;
	import classes.ui.UIStyle;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	
	public class SongButton extends UIComponent
	{
		private var core:EngineCore;
		public var songData:EngineLevel;
		
		private var _mtxGradient:Matrix
		private var _lblSongName:Label;
		private var _lblSongFlag:Label;
		private var _lblSongDifficulty:Label;
		
		private var _highlight:Boolean = false;
		private var _over:Boolean = false;
		
		public function SongButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, core:EngineCore = null, songData:EngineLevel = null)
		{
			this.core = core;
			this.songData = songData;
			super(parent, xpos, ypos);
			mouseEnabled = buttonMode = !songData.is_title_only;
			mouseChildren = false;
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			setSize(250, 40); // 27
			super.init();
			
			//- Gradient Box
			_mtxGradient = new Matrix();
			_mtxGradient.createGradientBox(200, 200, (Math.PI / 180) * 225);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			if (songData.is_title_only || songData.difficulty == 0)
			{
				_lblSongName = new Label(this, 5, 2, '<font color="' + UIStyle.ACTIVE_FONT_COLOR + '">' + songData.name + '</font>', true);
				_lblSongName.autoSize = TextFieldAutoSize.CENTER;
			}
			else
			{
				_lblSongName = new Label(this, 5, 2, songData.name);
				_lblSongFlag = new Label(this, 5, 2, Constant.getSongIcon(songData, core.user.levelranks.getEngineRanks(core.source).getRank(songData.id)), true);
				_lblSongFlag.autoSize = TextFieldAutoSize.RIGHT;
				_lblSongDifficulty = new Label(this, 5, 2, songData.difficulty.toString());
				_lblSongDifficulty.autoSize = TextFieldAutoSize.RIGHT;
			}
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFFFFFF, (highlight ? 0.8: 0.55), true);
			this.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], (highlight ? [0.5, 0.25] : [0.35, 0.1]), [0, 255], _mtxGradient);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
			
			// Song Divider
			if (songData.is_title_only || songData.difficulty == 0)
			{
				_lblSongName.setSize(width, height - 3);
			}
			else
			{
				_lblSongName.setSize(width - 150, height - 3);
				_lblSongFlag.x = width - 140;
				_lblSongFlag.setSize(110, height - 3);
				_lblSongDifficulty.x = width - 25;
				_lblSongDifficulty.setSize(20, height - 3);
			}
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal mouseOver handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			_over = true;
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			invalidate();
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			invalidate();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		public function get highlight():Boolean
		{
			return enabled && (_highlight || _over);
		}
		public function set highlight(val:Boolean):void
		{
			_highlight = val;
			invalidate();
		}
	
	}

}