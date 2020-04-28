import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import json

cred = credentials.Certificate(
    "/home/prateek/Downloads/campusbuddy-80598-firebase-adminsdk-h2gfd-076db2a4ac.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

file = open("/home/prateek/Downloads/contacts.min.json")
groups = json.load(file)
for group in groups:
    doc_ref = db.collection(u'groups').document()
    doc_ref.set({
        u'group_name': group["group_name"],
    })
    for dept in group["depts"]:
        d = doc_ref.collection('departments').document()
        d.set({
            u'dept_name': dept["dept_name"],
        })
        cont_doc = d.collection('contacts')
        for cont in dept["contacts"]:
            c = cont_doc.document()
            batch = db.batch()
            batch.set(c, {
                u"designation": cont["desg"] if "desg" in cont else "",
                u"contact_name": cont["name"],
                u"email": cont["email"] if "email" in cont else [],
                u"office": cont["iitr_o"] if "iitr_o" in cont else [],
                u"residence": cont["iitr_r"] if "iitr_r" in cont else [],
                u"bsnl": cont["bsnl_res"] if "bsnl_res" in cont else [],
            })
            batch.commit()
