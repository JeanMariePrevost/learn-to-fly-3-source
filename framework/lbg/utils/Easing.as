/*
/*
        TERMS OF USE - EASING EQUATIONS
        ---------------------------------------------------------------------------------
        Open source under the BSD License.

        Copyright © 2001 Robert Penner All rights reserved.

        Redistribution and use in source and binary forms, with or without
        modification, are permitted provided that the following conditions are met:

        Redistributions of source code must retain the above copyright notice, this
        list of conditions and the following disclaimer. Redistributions in binary
        form must reproduce the above copyright notice, this list of conditions and
        the following disclaimer in the documentation and/or other materials provided
        with the distribution. Neither the name of the author nor the names of
        contributors may be used to endorse or promote products derived from this
        software without specific prior written permission.

        THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
        AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
        IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
        DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
        FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
        DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
        SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
        CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
        OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
        OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
        ---------------------------------------------------------------------------------
*/

package lbg.utils
{        
        public class Easing
        {
                private static const PI_M2:Number = Math.PI*2;
                private static const PI_D2:Number = Math.PI/2;
                
                /*
                Linear
                ---------------------------------------------------------------------------------
                */
                public static var linear:Function = easeLinear;
                public static var none:Function = easeLinear;
                public static function easeLinear (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return modValue*time/duration + startValue;
                }
        
                /*
                Sine
                ---------------------------------------------------------------------------------
                */
                public static function easeInSine (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return -modValue * Math.cos(time/duration * PI_D2) + modValue + startValue;
                }
                public static function easeOutSine (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return modValue * Math.sin(time/duration * PI_D2) + startValue;
                }
                public static function easeBothInOutSine (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return -modValue/2 * (Math.cos(Math.PI*time/duration) - 1) + startValue;
                }

                /*
                Quintic
                ---------------------------------------------------------------------------------
                */
                public static function easeInQuint (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return modValue*(time/=duration)*time*time*time*time + startValue;
                }
                public static function easeOutQuint (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return modValue*((time=time/duration-1)*time*time*time*time + 1) + startValue;
                }
                public static function easeBothInOutQuint (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        if ((time/=duration/2) < 1) return modValue/2*time*time*time*time*time + startValue;
                        return modValue/2*((time-=2)*time*time*time*time + 2) + startValue;
                }

                /*
                Quartic
                ---------------------------------------------------------------------------------
                */
                public static function easeInQuart (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return modValue*(time/=duration)*time*time*time + startValue;
                }
                public static function easeOutQuart (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return -modValue * ((time=time/duration-1)*time*time*time - 1) + startValue;
                }
                public static function easeBothInOutQuart (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        if ((time/=duration/2) < 1) return modValue/2*time*time*time*time + startValue;
                        return -modValue/2 * ((time-=2)*time*time*time - 2) + startValue;
                }

                /*
                Quadratic
                ---------------------------------------------------------------------------------
                */
                public static function easeInQuad (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return modValue*(time/=duration)*time + startValue;
                }
                public static function easeOutQuad (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return -modValue *(time/=duration)*(time-2) + startValue;
                }
                public static function easeBothInOutQuad (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        if ((time/=duration/2) < 1) return modValue/2*time*time + startValue;
                        return -modValue/2 * ((--time)*(time-2) - 1) + startValue;
                }

                /*
                Exponential
                ---------------------------------------------------------------------------------
                */
                public static function easeInExpo (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return (time==0) ? startValue : modValue * Math.pow(2, 10 * (time/duration - 1)) + startValue;
                }
                public static function easeOutExpo (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return (time==duration) ? startValue+modValue : modValue * (-Math.pow(2, -10 * time/duration) + 1) + startValue;
                }
                public static function easeBothInOutExpo (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        if (time==0) return startValue;
                        if (time==duration) return startValue+modValue;
                        if ((time/=duration/2) < 1) return modValue/2 * Math.pow(2, 10 * (time - 1)) + startValue;
                        return modValue/2 * (-Math.pow(2, -10 * --time) + 2) + startValue;
                }

                /*
                Elastic
                ---------------------------------------------------------------------------------
                */
                public static function easeInElastic (time:Number, startValue:Number, modValue:Number, duration:Number, a:Number=undefined, p:Number=undefined):Number
                {
                        var s:Number;
                        if (time==0) return startValue; if ((time/=duration)==1) return startValue+modValue; if (!p) p=duration*.3;
                        if (!a || a < Math.abs(modValue)) { a=modValue; s=p/4; }
                        else s = p/PI_M2 * Math.asin (modValue/a);
                        return -(a*Math.pow(2,10*(time-=1)) * Math.sin( (time*duration-s)*PI_M2/p )) + startValue;
                }
                public static function easeOutElastic (time:Number, startValue:Number, modValue:Number, duration:Number, a:Number=undefined, p:Number=undefined):Number
                {
                        var s:Number;
                        if (time==0) return startValue; if ((time/=duration)==1) return startValue+modValue; if (!p) p=duration*.3;
                        if (!a || a < Math.abs(modValue)) { a=modValue; s=p/4; }
                        else s = p/PI_M2 * Math.asin (modValue/a);
                        return (a*Math.pow(2,-10*time) * Math.sin( (time*duration-s)*PI_M2/p ) + modValue + startValue);
                }
                public static function easeBothInOutElastic (time:Number, startValue:Number, modValue:Number, duration:Number, a:Number=undefined, p:Number=undefined):Number
                {
                        var s:Number;
                        if (time==0) return startValue; if ((time/=duration/2)==2) return startValue+modValue; if (!p) p=duration*(.3*1.5);
                        if (!a || a < Math.abs(modValue)) { a=modValue; s=p/4; }
                        else s = p/PI_M2 * Math.asin (modValue/a);
                        if (time < 1) return -.5*(a*Math.pow(2,10*(time-=1)) * Math.sin( (time*duration-s)*PI_M2/p )) + startValue;
                        return a*Math.pow(2,-10*(time-=1)) * Math.sin( (time*duration-s)*PI_M2/p )*.5 + modValue + startValue;
                }

                /*
                Circular
                ---------------------------------------------------------------------------------
                */
                public static function easeInCircular (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return -modValue * (Math.sqrt(1 - (time/=duration)*time) - 1) + startValue;
                }
                public static function easeOutCircular (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return modValue * Math.sqrt(1 - (time=time/duration-1)*time) + startValue;
                }
                public static function easeBothInOutCircular (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        if ((time/=duration/2) < 1) return -modValue/2 * (Math.sqrt(1 - time*time) - 1) + startValue;
                        return modValue/2 * (Math.sqrt(1 - (time-=2)*time) + 1) + startValue;
                }

                /*
                Back
                ---------------------------------------------------------------------------------
                */
                public static function easeInBack (time:Number, startValue:Number, modValue:Number, duration:Number, s:Number=1.70158):Number
                {
                        return modValue*(time/=duration)*time*((s+1)*time - s) + startValue;
                }
                public static function easeOutBack (time:Number, startValue:Number, modValue:Number, duration:Number, s:Number=1.70158):Number
                {
                        return modValue*((time=time/duration-1)*time*((s+1)*time + s) + 1) + startValue;
                }
                public static function easeBothInOutBack (time:Number, startValue:Number, modValue:Number, duration:Number, s:Number=1.70158):Number
                {
                        if ((time/=duration/2) < 1) return modValue/2*(time*time*(((s*=(1.525))+1)*time - s)) + startValue;
                        return modValue/2*((time-=2)*time*(((s*=(1.525))+1)*time + s) + 2) + startValue;
                }

                /*
                Bounce
                ---------------------------------------------------------------------------------
                */
                public static function easeInBounce (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return modValue - easeOutBounce (duration-time, 0, modValue, duration) + startValue;
                }
                public static function easeOutBounce (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        if ((time/=duration) < (1/2.75)) {
                                return modValue*(7.5625*time*time) + startValue;
                        } else if (time < (2/2.75)) {
                                return modValue*(7.5625*(time-=(1.5/2.75))*time + .75) + startValue;
                        } else if (time < (2.5/2.75)) {
                                return modValue*(7.5625*(time-=(2.25/2.75))*time + .9375) + startValue;
                        } else {
                                return modValue*(7.5625*(time-=(2.625/2.75))*time + .984375) + startValue;
                        }
                }
                public static function easeBothInOutBounce (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        if (time < duration/2) return easeInBounce (time*2, 0, modValue, duration) * .5 + startValue;
                        else return easeOutBounce (time*2-duration, 0, modValue, duration) * .5 + modValue*.5 + startValue;
                }

                /*
                Cubic
                ---------------------------------------------------------------------------------
                */
                public static function easeInCubic (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return modValue*(time/=duration)*time*time + startValue;
                }
                public static function easeOutCubic (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        return modValue*((time=time/duration-1)*time*time + 1) + startValue;
                }
                public static function easeBothInOutCubic (time:Number, startValue:Number, modValue:Number, duration:Number):Number
                {
                        if ((time/=duration/2) < 1) return modValue/2*time*time*time + startValue;
                        return modValue/2*((time-=2)*time*time + 2) + startValue;
                }
        }
}