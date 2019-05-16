import {promisify} from 'util';
import {exec as execCallback} from 'child_process';
import {readFileSync} from 'fs';

const exec = promisify(execCallback);

let file = process.argv[2];
if (!file) {
  file = 'cnc2.scad';
}

class MaterialsLog {
  constructor(log) {
    this.log = log;

    this._logToRows();
    this._rowsToParts();

    Object.freeze(this);
    for (const key of Object.keys(this)) {
      Object.freeze(this[key]);
    }
  }

  _logToRows() {
    const rows = this.log.trim().split(/\n+/).filter((row) => row.match(/^ECHO:\s+/)).map((row) => {
      return row.replace(/^ECHO:\s+"/, '').replace(/",\s+/g, '').replace(/,\s+"\s+/g, ' ');
    });

    rows.sort();

    this.rows = rows;
  }

  _rowsToParts() {
    const counts = {};
    for (const row of this.rows) {
      if (counts[row]) {
        counts[row]++;
      } else {
        counts[row] = 1;
      }
    }

    const parts = [];
    for (const info of Object.keys(counts)) {
      const matches = info.match(/(.+?):\s*(.+)/);

      const parameters = {}
      const keyPairs = matches[2].split(/\s+/);
      for (const pair of keyPairs) {
        let [key, value] = pair.split(/=/);

        if (!isNaN(value)) {
          value = parseFloat(value);
        }

        parameters[key] = value;
      }

      parameters.toString = () => {
        let output = '';
        for (const [key, value] of Object.entries(parameters)) {
          if (!(value instanceof Function)) {
            output += ` ${key}=${value}`;
          }
        }
        return output.trim();
      };

      Object.freeze(parameters);

      const part = {
        name: matches[1],
        parameters,
        count: counts[info]
      };

      Object.freeze(part);
      parts.push(part);
    }

    this.parts = parts;
  }

  toString() {
    let output = '# Bill of materials (aluminum frame)\n\n!(CNC)[cnc.png]\n\n## Parts\n\n';
    for (const part of this.parts) {
      output += `* ${part.count} x ${part.name} (${part.parameters.toString()})\n`;
    }

    const lengths = {};
    for (const part of this.parts) {
      if (part.parameters.length) {
        const key = `${part.name} (${part.parameters.toString().replace(/length=[\d.]+\s*/, '')})`;
        if (!lengths[key]) {
          lengths[key] = 0;
        }

        let length = part.parameters.length;
        if (part.count) {
          length *= part.count;
        }

        lengths[key] += length;
      }
    }

    if (Object.keys(lengths).length > 0) {
      output += '\n### Total lengths:\n\n';

      for (const [key, value] of Object.entries(lengths)) {
        output += `* ${key} = ${value}\n`;
      }
    }

    return output.trim();
  }
}

function build(file) {
  return new Promise((resolve, reject) => {
    exec(`openscad -o cnc.png ${file}`).then((output) => {
      resolve(output.stdout + output.stderr);
    }).catch(reject);
  });
}

if (!file) {
  console.log('USAGE: node --require esm bom.js [part.scad|build.log]');
} else if (file.match(/\.scad$/i)) {
  build(file).then((log) => {
    console.log(new MaterialsLog(log).toString());
  });
} else {
  const log = readFileSync(file, 'utf-8');
  console.log(new MaterialsLog(log).toString());
}
