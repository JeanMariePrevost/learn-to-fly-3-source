package src.game.particles 
{
	import src.system.ProfileState;
	/**
	 * ...
	 * @author ...
	 */
	public class Particles 
	{
		protected static var _builder:ParticleBuilder = new ParticleBuilder();
		protected static var _builderNull:ParticleBuilder = new ParticleBuilderNull();
		
		public static function get builder():ParticleBuilder {
			if (ProfileState.instance.optionSmoke == "On") {
				return _builder;
			}else {
				return _builderNull;
			}
			
		}
	}

}