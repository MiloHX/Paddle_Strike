// Auto-generated
package ;
class Main {
    public static inline var projectName = 'Paddle_Strike';
    public static inline var projectPackage = 'arm';
    public static inline var resolutionSize = 1080;
    public static function main() {
        iron.object.BoneAnimation.skinMaxBones = 8;
        iron.object.LightObject.cascadeCount = 4;
        iron.object.LightObject.cascadeSplitFactor = 0.800000011920929;
        armory.system.Starter.numAssets = 76;
        armory.system.Starter.drawLoading = armory.trait.internal.LoadingScreen.render;
        armory.system.Starter.main(
            'Scene',
            0,
            false,
            true,
            false,
            1280,
            960,
            1,
            true,
            armory.renderpath.RenderPathCreator.get
        );
    }
}
