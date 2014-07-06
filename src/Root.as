package
{
    import flash.system.System;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;
    import starling.utils.AssetManager;
    
    import utils.ProgressBar;
	
    public class Root extends Sprite
    {
        private static var sAssets:AssetManager;
        
        private var _activeScene:Sprite;
        
        public function start(background:Texture, assets:AssetManager):void
        {
            sAssets = assets;
            
			var backgroundImage:Image = new Image(background);
            addChild(backgroundImage);
            
            var progressBar:ProgressBar = new ProgressBar(175, 20);
            progressBar.x = (background.width  - progressBar.width)  / 2;
            progressBar.y = (background.height - progressBar.height) / 2;
            progressBar.y = background.height * 0.85;
            addChild(progressBar);
            
            assets.loadQueue(function onProgress(ratio:Number):void
            {
                progressBar.ratio = ratio;
				
                if (ratio == 1)
                    Starling.juggler.delayCall(function():void
                    {
                        progressBar.removeFromParent(true);
						backgroundImage.removeFromParent(true);
                        showScene(App);
                        
                        System.pauseForGCIfCollectionImminent(0);
                        System.gc();
                    }, 0.15);
            });
        }
        
        private function showScene(scene:Class):void
        {
            if (_activeScene) _activeScene.removeFromParent(true);
            _activeScene = new scene();
            addChild(_activeScene);
        }
        
        public static function get assets():AssetManager { return sAssets; }
    }
}