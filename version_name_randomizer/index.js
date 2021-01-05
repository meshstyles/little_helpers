const config = require('./config.json')

const adjGer = Math.floor(Math.random() * config.de.meta.adjMax);
const nounGer = Math.floor(Math.random() * config.de.meta.nounMax);
console.log(config.de.adj.loc[adjGer] + " " + config.de.noun.loc[nounGer] );
console.log(config.de.adj.eng[adjGer] + " " + config.de.noun.eng[nounGer] );

const adjCn = Math.floor(Math.random() * config.cn.meta.adjMax);
const nounCn = Math.floor(Math.random() * config.cn.meta.nounMax);
console.log(config.cn.adj.loc[adjCn] + " " + config.cn.noun.loc[nounCn]);
console.log(config.cn.adj.eng[adjCn] + " " + config.cn.noun.eng[nounCn]);

