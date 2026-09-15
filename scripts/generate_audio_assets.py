import os
import math
import struct
import wave

def create_wav(filepath, duration_sec, sample_rate, wave_generator):
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    num_samples = int(duration_sec * sample_rate)
    with wave.open(filepath, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(sample_rate)
        
        frames = bytearray()
        for i in range(num_samples):
            t = float(i) / sample_rate
            sample_val = wave_generator(t, duration_sec)
            # Clamp to -1.0 .. 1.0
            sample_val = max(-1.0, min(1.0, sample_val))
            int_val = int(sample_val * 32767.0)
            frames.extend(struct.pack('<h', int_val))
        
        wav_file.writeframes(frames)
    print(f"Generated {filepath} ({num_samples} samples)")

def piano_synth(freq):
    def generator(t, duration):
        # ADSR Decay Envelope
        decay = math.exp(-t * 3.5)
        # Fundamental + Piano Harmonics
        f = freq
        val = 0.60 * math.sin(2 * math.pi * f * t) \
            + 0.25 * math.sin(2 * math.pi * f * 2 * t) \
            + 0.10 * math.sin(2 * math.pi * f * 3 * t) \
            + 0.05 * math.sin(2 * math.pi * f * 4 * t)
        return val * decay
    return generator

def elec_kick_synth(t, duration):
    # 808 Pitch Drop Sine Sweep Sub Kick
    freq = 140.0 * math.exp(-t * 25.0) + 40.0
    decay = math.exp(-t * 6.0)
    val = math.sin(2 * math.pi * freq * t)
    # Subtle overdrive distortion
    val = math.tanh(val * 1.5)
    return val * decay

def elec_snare_synth(t, duration):
    # Tone + Noise Burst
    tone_freq = 180.0 * math.exp(-t * 20.0) + 100.0
    tone_decay = math.exp(-t * 15.0)
    tone = math.sin(2 * math.pi * tone_freq * t) * tone_decay
    
    # White noise generator via pseudo-random hash
    noise_decay = math.exp(-t * 12.0)
    noise = (math.sin(t * 123456.789) % 1.0 - 0.5) * 2.0 * noise_decay
    return (0.4 * tone + 0.6 * noise) * math.exp(-t * 4.0)

def elec_clap_synth(t, duration):
    # Multi-burst transient clap
    decay = math.exp(-t * 14.0)
    burst = 0.0
    if t < 0.015:
        burst = 1.0
    elif 0.020 < t < 0.035:
        burst = 0.8
    elif 0.040 < t < 0.055:
        burst = 0.6
    elif 0.060 < t:
        burst = 1.0 * decay
    
    noise = (math.sin(t * 987654.321) % 1.0 - 0.5) * 2.0
    return noise * burst * decay

def elec_hat_closed_synth(t, duration):
    decay = math.exp(-t * 40.0)
    noise = (math.sin(t * 555555.55) % 1.0 - 0.5) * 2.0
    # High-pass filter simulation (high frequency oscillation)
    metallic = math.sin(2 * math.pi * 8000.0 * t) * 0.4 + noise * 0.6
    return metallic * decay

def elec_hat_open_synth(t, duration):
    decay = math.exp(-t * 10.0)
    noise = (math.sin(t * 555555.55) % 1.0 - 0.5) * 2.0
    metallic = math.sin(2 * math.pi * 7500.0 * t) * 0.4 + noise * 0.6
    return metallic * decay

def elec_tom_synth(t, duration):
    freq = 130.0 * math.exp(-t * 12.0) + 60.0
    decay = math.exp(-t * 5.0)
    return math.sin(2 * math.pi * freq * t) * decay

def elec_synth_hit_synth(t, duration):
    decay = math.exp(-t * 4.0)
    # Chord triad (Root, Minor 3rd, 5th)
    root = 220.0 # A3
    m3 = 261.63  # C4
    p5 = 329.63  # E4
    chord = math.sin(2 * math.pi * root * t) * 0.4 \
          + math.sin(2 * math.pi * m3 * t) * 0.3 \
          + math.sin(2 * math.pi * p5 * t) * 0.3
    return chord * decay

def elec_rim_synth(t, duration):
    decay = math.exp(-t * 30.0)
    tone = math.sin(2 * math.pi * 1600.0 * t)
    return tone * decay

def main():
    sample_rate = 44100
    base_dir = "/home/chinmay/Projects/Rivora/assets/sounds"
    
    # 1. Piano Notes (13 Chromatic Notes from C4 to C5)
    piano_notes = [
        ("c4", 261.63),
        ("cs4", 277.18),
        ("d4", 293.66),
        ("ds4", 311.13),
        ("e4", 329.63),
        ("f4", 349.23),
        ("fs4", 369.99),
        ("g4", 392.00),
        ("gs4", 415.30),
        ("a4", 440.00),
        ("as4", 466.16),
        ("b4", 493.88),
        ("c5", 523.25),
    ]
    
    for note_name, freq in piano_notes:
        path = os.path.join(base_dir, "piano", f"{note_name}.wav")
        create_wav(path, 1.2, sample_rate, piano_synth(freq))
        
    # 2. Electronic Drum Pad Sounds (8 MPC Pads)
    pad_sounds = [
        ("elec_kick.wav", elec_kick_synth, 0.5),
        ("elec_snare.wav", elec_snare_synth, 0.4),
        ("elec_clap.wav", elec_clap_synth, 0.4),
        ("elec_hihat_closed.wav", elec_hat_closed_synth, 0.2),
        ("elec_hihat_open.wav", elec_hat_open_synth, 0.5),
        ("elec_tom.wav", elec_tom_synth, 0.5),
        ("elec_synth_hit.wav", elec_synth_hit_synth, 0.8),
        ("elec_rim.wav", elec_rim_synth, 0.2),
    ]
    
    for filename, gen, duration in pad_sounds:
        path = os.path.join(base_dir, "pad", filename)
        create_wav(path, duration, sample_rate, gen)
        
    print("All 21 new audio assets successfully generated!")

if __name__ == "__main__":
    main()
