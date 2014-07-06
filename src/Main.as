package 
{
	import flash.desktop.NativeApplication;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    
    import starling.core.Starling;
    import starling.events.Event;
    import starling.textures.Texture;
    import starling.utils.AssetManager;
    import starling.utils.RectangleUtil;
    import starling.utils.ScaleMode;
    import starling.utils.formatString;
	
	public class Main extends Sprite 
	{
        [Embed(source="/system/startup.jpg")]
        private static var Background:Class;
        
        [Embed(source="/system/startupHD.jpg")]
        private static var BackgroundHD:Class;
        
        private var _starling:Starling;
		
		public function Main():void 
		{
            var stageWidth:int   = Constants.STAGE_WIDTH;
            var stageHeight:int  = Constants.STAGE_HEIGHT;
			var resourcePath:String = Constants.RESOURCE_PATH;
            var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
            
            Starling.multitouchEnabled = true;
            Starling.handleLostContext = !iOS;
            
            var viewPort:Rectangle = RectangleUtil.fit(
                new Rectangle(0, 0, stageWidth, stageHeight), 
                new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
                ScaleMode.SHOW_ALL);
            
            var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
            var appDir:File = File.applicationDirectory;
            var assets:AssetManager = new AssetManager(scaleFactor);
            
            assets.verbose = Capabilities.isDebugger;
            assets.enqueue(
                appDir.resolvePath(resourcePath+"audio"),
                appDir.resolvePath(formatString(resourcePath+"fonts/{0}x", scaleFactor)),
                appDir.resolvePath(formatString(resourcePath+"textures/{0}x", scaleFactor))
            );
            
            var backgroundClass:Class = scaleFactor == 1 ? Background : BackgroundHD;
            var background:Bitmap = new backgroundClass();
            Background = BackgroundHD = null;
            
            background.x = viewPort.x;
            background.y = viewPort.y;
            background.width  = viewPort.width;
			background.height = viewPort.height;
            background.smoothing = true;
            addChild(background);
            
            _starling = new Starling(Root, stage, viewPort);
            _starling.stage.stageWidth  = stageWidth;
            _starling.stage.stageHeight = stageHeight;
            _starling.simulateMultitouch  = false;
            _starling.enableErrorChecking = Capabilities.isDebugger;
            
            _starling.addEventListener(starling.events.Event.ROOT_CREATED, 
                function(event:Object, app:Root):void
                {
                    _starling.removeEventListener(starling.events.Event.ROOT_CREATED, arguments.callee);
                    removeChild(background);
                    background = null;
                    
                    var bgTexture:Texture = Texture.fromEmbeddedAsset(backgroundClass, false, false, scaleFactor);
                    
                    app.start(bgTexture, assets);
                    _starling.start();
                });
            
            NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.ACTIVATE, function (e:*):void { _starling.start(); });
            
            NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.DEACTIVATE, function (e:*):void { _starling.stop(true); });
		}
	}
}