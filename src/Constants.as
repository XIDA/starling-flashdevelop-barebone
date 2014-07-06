package
{
    import starling.errors.AbstractClassError;

    public class Constants
    {
        public function Constants() { throw new AbstractClassError(); }
        
        public static const STAGE_WIDTH:int  = 480;
        public static const STAGE_HEIGHT:int = 320;
		public static const RESOURCE_PATH:String = "resources/"
    }
}