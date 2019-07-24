from flask import Flask, request, abort
from flask_restful import Resource, Api, reqparse

import os
import hashlib
import datetime

app = Flask(__name__)
api = Api(app)


class HelloWorld(Resource):
  def get(self):
    return {'hello': 'world'}


class WarUpdate(Resource):
    def post(self):
        try:
            parser = reqparse.RequestParser()
            parser.add_argument('tomcatPath')
            parser.add_argument('fileName')
            args = parser.parse_args()

            tomcatPath = args.get('tomcatPath')
            if not tomcatPath:
                abort(500, "tomcatPath is null")
            fileName = args.get('fileName')
            if not fileName:
                abort(500, "fileName is null")
            file = request.files.get('file')
            if not file:
                abort(500, "file not exists")

            context=re.sub('\\..*', '', fileName)
            os.system('mkdir -p upload')
            file.save(f'upload/{fileName}')

            os.system(f'sh -ex updateWar.sh {tomcatPath} {context} upload/{fileName}')
            return {'status':1}
        except Exception as e:
            abort(500, str(e))
        finally:
            os.system('rm -rf swap.war')


api.add_resource(HelloWorld, '/')
api.add_resource(WarUpdate, '/update')


@app.before_request
def auth():
    if(request.path.startswith('/error')):
        return
    parser = reqparse.RequestParser()
    parser.add_argument('token', location='headers')
    args = parser.parse_args()

    token = args.get('token')
    if token:
        secretKey = 'UuQjLlru4SOuGGLKWn1cGH0YeBZQlFfD'

        content = secretKey+datetime.datetime.now().strftime("%Y-%m-%d_%H")
        m2 = hashlib.md5()
        m2.update(content.encode("UTF-8"))
        if m2.hexdigest() == token:
            return

        content = secretKey+(datetime.datetime.now()+datetime.timedelta(hours=-1)).strftime("%Y-%m-%d_%H")
        m2 = hashlib.md5()
        m2.update(content.encode("UTF-8"))
        if m2.hexdigest() == token:
            return

        content = secretKey+(datetime.datetime.now()+datetime.timedelta(hours=1)).strftime("%Y-%m-%d_%H")
        m2 = hashlib.md5()
        m2.update(content.encode("UTF-8"))
        if m2.hexdigest() == token:
            return
    return abort(403, "FORBIDDEN")


if __name__ == '__main__':
  app.run(host='0.0.0.0', port=8081)
