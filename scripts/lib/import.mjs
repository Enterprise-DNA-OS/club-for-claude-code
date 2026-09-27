import {readFileSync} from 'node:fs';
import {parseCsv,pick} from './csv.mjs';
function date(s,order){
 if(!s)return null;let iso=s;
 if(!/^\d{4}-\d{2}-\d{2}$/.test(s)){
  const m=s.match(/^(\d{1,2})[/.](\d{1,2})[/.](\d{4})$/);
  if(!m||!['DMY','MDY'].includes(order))throw Error(`Date ${s}: use ISO dates or --date-order=DMY or MDY`);
  iso=`${m[3]}-${(order==='DMY'?m[2]:m[1]).padStart(2,'0')}-${(order==='DMY'?m[1]:m[2]).padStart(2,'0')}`;
 }
 const d=new Date(iso+'T00:00:00Z');if(Number.isNaN(d.getTime())||d.toISOString().slice(0,10)!==iso)throw Error('Invalid date '+s);return iso;
}
export async function importMembers(db,file,opts={}){
 const raw=parseCsv(readFileSync(file,'utf8'));if(!raw.length)throw Error('No contact rows found');const seen=new Set();
 const rows=raw.map((r,i)=>{
  const get=(...keys)=>pick(r,...keys).trim();
  const external=get('Contact ID','ID','Contact Number'),name=get('Full Name','Name')||[get('First Name','Given Name'),get('Last Name','Surname')].filter(Boolean).join(' ');
  if(!external||!name)throw Error(`Row ${i+2}: Contact ID (or ID) and a name required. See docs/replace-tidyhq.md.`);
  if(seen.has(external))throw Error('Duplicate Contact ID '+external);seen.add(external);
  const vendorStatus=get('Membership Status','Status').toLowerCase();
  const statuses={active:'active',current:'active',expired:'lapsed',lapsed:'lapsed',pending:'pending',suspended:'suspended',cancelled:'contact',canceled:'contact',archived:'archived','':'contact'};
  if(!(vendorStatus in statuses))throw Error(`Row ${i+2}: unknown membership status ${vendorStatus}`);
  return {external,name,status:statuses[vendorStatus],email:get('Email','Email Address')||null,organisation:get('Organisation','Organization')||null,level:get('Membership Level','Membership'),joined:date(get('Subscription Start Date','Member Since','Joined On'),opts.dateOrder),renewal:date(get('Subscription End Date','Expiry Date','Renewal Due'),opts.dateOrder),raw:r};
 });
 await db.exec('BEGIN');let inserted=0,updated=0;
 try{
  for(const r of rows){
   let level=null;if(r.level){const [l]=await db.query('insert into levels(name) values($1) on conflict(name) do update set name=excluded.name returning id',[r.level]);level=l.id;}
   const existing=await db.query('select id from members where external_id=$1',[r.external]);if(existing.length)updated++;else inserted++;
   await db.query(`insert into members(external_id,name,email,organisation,level_id,status,joined_on,renewal_due,source_data) values($1,$2,$3,$4,$5,$6,$7,$8,$9) on conflict(external_id) do update set name=excluded.name,email=excluded.email,organisation=excluded.organisation,level_id=excluded.level_id,status=excluded.status,joined_on=excluded.joined_on,renewal_due=excluded.renewal_due,source_data=excluded.source_data`,[r.external,r.name,r.email,r.organisation,level,r.status,r.joined,r.renewal,JSON.stringify(r.raw)]);
  }
  if(opts.dryRun)await db.exec('ROLLBACK');else{await db.query("insert into audit(name,detail) values('import tidyhq',$1)",[JSON.stringify({inserted,updated})]);await db.exec('COMMIT');}
  return [{inserted,updated,dry_run:!!opts.dryRun,warning:'Contact snapshot imported. Review membership dates and fees. Consent is not inferred. Extra source columns preserved; family links, financial history and multiple memberships require mapping.'}];
 }catch(e){await db.exec('ROLLBACK');throw e;}
}
