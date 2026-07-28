from pathlib import Path
import subprocess,sys
root=Path(__file__).resolve().parent
raise SystemExit(subprocess.run([sys.executable,'-m','unittest','discover','-s',str(root/'python'),'-p','test_*.py','-v'], cwd=root).returncode)
